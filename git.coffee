# git.coffee
http = require 'http'
url = require 'url'
exec = require("child_process").exec
restartNode = (e,s,t)-> 
	exec "forever restart /mydata/myweb/jquerg/app.js"
gitpull = (porject)->
	exec "git pull",restartNode
	yes
routes = (req,res)->
	pathname = url.parse(req.url).pathname
	if pathname is "/update" and req.method.toLowerCase() is "post"
		gitpull()
	else
		return '404'
req = http.createServer((req,res)->
	routes(req,res)
	res.end()
	).listen 9998