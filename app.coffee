KEY = "express.sid"
SECRET = 'express'
path = require 'path'
express = require 'express' 
config = require('./config').config
routes = require './routes'
fs = require('fs')
# here for socket
cookie = express.cookieParser config.session_secret 
store = new express.session.MemoryStore()
session = express.session
	secret: config.session_secret
	key: KEY
	store: store
app = express()
server = require('http').createServer app
io = require('socket.io').listen server

app.configure ->
	viewsRoot = path.join __dirname, 'views'
	app.set 'view engine', 'jade'
	app.set 'views', viewsRoot
	app.use express.cookieParser()
	app.use session
	app.use express.bodyParser()
	app.use (req,res,next)->
		res.locals.token = req.session._csrf
		res.locals.config = config
		res.locals.title = config.name
		next()
app.use (req,res,next)->
	msgs = req.session.messages || []
	res.locals.messages = msgs
	res.locals.hasMessages = !! msgs.length
	req.session.messages = []
	next()

maxAge = 3600000 * 24 * 30
staticDir = path.join __dirname, 'public'
app.configure 'development',->
	app.use express.static staticDir
	app.use express.errorHandler()
	app.set 'view cache', true

routes app
usersWS = {}
server.listen 8888,"127.0.0.1"
io.set 'authorization', (data, accept)->
	cookie data, {}, (err)->
		if !err
			sessionID = data.signedCookies[KEY]
			store.get sessionID, (err, session)->
				if err || !session
					accept null, false
				else
					data.session = session
					accept null, true
		else
			accept null, false

io.sockets.on 'connection', (socket)->
	userse = socket.handshake.session
	roomname = userse.roomname
	refresh_online = -> 
		console.log io.sockets.manager.rooms
		io.sockets.emit 'online list', io.sockets.manager.rooms["/"+roomname];
	empty_room = -> 
		if typeof io.sockets.manager.rooms["/"+roomname] is "undefined"
			console.log 'no one in this room'
	default_info = ->
		roomlist = io.sockets.clients(roomname)
		roomlist[0].emit 'get default info', who:socket.id if roomlist.length >1  

	socket.on 'login',  (data)-> 
		socket.join roomname
		refresh_online()
		default_info()
	socket.on 'message', (data)->

	socket.on 'create default info', (data)->
		io.sockets.socket(data.who).emit 'create default info',content:data.content

	socket.on 'editor', (data)->
		socket.broadcast.to(roomname).emit 'editor', data
	
	socket.on 'disconnect', ->
		setTimeout ->
			refresh_online()
			empty_room()
		,100
console.log "Project start."
