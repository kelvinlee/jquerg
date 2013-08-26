config = require('../config').config
chars = ['','0','1','2','3','4','5','6','7','8','9','a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z','A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z']
modetypelist = {"Html":'html',"Css":'css',"Javascript":'javascript',"Jade":'jade',"Less":'less',"Coffeescript":'coffee'}
exports.before = (req,res, next)->
	next()
exports.room = (req,res, next)->
	rid = req.params.room_id
	return res.redirect '/' if rid.length isnt 7
	req.session.roomname = rid
	res.render 'room' ,modetypelist:modetypelist
exports.create = (req,res, next)->
	room_id = generateMixed 7
	res.redirect '/room/'+room_id
generateMixed = (n)->
	res = "" 
	res += chars[Math.ceil(Math.random()*(chars.length-1))] for i in [1..7]
	res