// Generated by CoffeeScript 1.6.3
var exec, gitpull, http, req, restartNode, routes, url;

http = require('http');

url = require('url');

exec = require("child_process").exec;

restartNode = function(e, s, t) {
  return exec("forever restart /mydata/myweb/jquerg/app.js");
};

gitpull = function(porject) {
  exec("git pull", restartNode);
  return true;
};

routes = function(req, res) {
  var pathname;
  pathname = url.parse(req.url).pathname;
  if (pathname === "/update" && req.method.toLowerCase() === "post") {
    return gitpull();
  } else {
    return '404';
  }
};

req = http.createServer(function(req, res) {
  routes(req, res);
  return res.end();
}).listen(9998);