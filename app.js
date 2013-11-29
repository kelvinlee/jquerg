// Generated by CoffeeScript 1.6.3
var KEY,SECRET,app,config,cookie,express,fs,io,maxAge,path,routes,server,session,staticDir,store,usersWS;KEY="express.sid";SECRET="express";path=require("path");express=require("express");config=require("./config").config;routes=require("./routes");fs=require("fs");cookie=express.cookieParser(config.session_secret);store=new express.session.MemoryStore;session=express.session({secret:config.session_secret,key:KEY,store:store});app=express();server=require("http").createServer(app);io=require("socket.io").listen(server);app.configure(function(){var e;e=path.join(__dirname,"views");app.set("view engine","jade");app.set("views",e);app.use(express.cookieParser());app.use(session);app.use(express.bodyParser());return app.use(function(e,t,n){t.locals.token=e.session._csrf;t.locals.config=config;t.locals.title=config.name;return n()})});app.use(function(e,t,n){var r;r=e.session.messages||[];t.locals.messages=r;t.locals.hasMessages=!!r.length;e.session.messages=[];return n()});maxAge=2592e6;staticDir=path.join(__dirname,"public");app.configure("development",function(){app.use(express["static"](staticDir));app.use(express.errorHandler());return app.set("view cache",!0)});routes(app);usersWS={};server.listen(8888,config.serverIp);io.set("authorization",function(e,t){return cookie(e,{},function(n){var r;if(!n){r=e.signedCookies[KEY];return store.get(r,function(n,r){if(n||!r)return t(null,!1);e.session=r;return t(null,!0)})}return t(null,!1)})});io.sockets.on("connection",function(e){var t,n,r,i,s;s=e.handshake.session;i=s.roomname;r=function(){console.log(io.sockets.manager.rooms);return io.sockets.emit("online list",io.sockets.manager.rooms["/"+i])};n=function(){if(typeof io.sockets.manager.rooms["/"+i]=="undefined")return console.log("no one in this room")};t=function(){var t;t=io.sockets.clients(i);if(t.length>1)return t[0].emit("get default info",{who:e.id})};e.on("login",function(n){e.join(i);r();return t()});e.on("message",function(t){console.log("message: "+t);return e.broadcast.emit("message",t)});e.on("create default info",function(e){return io.sockets.socket(e.who).emit("create default info",{content:e.content,list:e.list})});e.on("editor",function(t){return e.broadcast.to(i).emit("editor",t)});e.on("create editor",function(t){return e.broadcast.to(i).emit("create editor",t)});e.on("destroy editor",function(t){return e.broadcast.to(i).emit("destroy editor",t)});e.on("chat",function(t){console.log("chat: ",t);return e.broadcast.to(i).emit("chat",t)});return e.on("disconnect",function(){return setTimeout(function(){r();return n()},100)})});console.log("Project start.");