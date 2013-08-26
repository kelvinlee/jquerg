page = require './controllers/page'
room = require './controllers/room'

module.exports = (app)->
	app.get '/', page.homepage
	app.get '/room', room.create
  	app.get '/room/:room_id', room.room

console.log 'routes loaded.'