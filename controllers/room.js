// Generated by CoffeeScript 1.6.3
var chars, config, generateMixed, modetypelist;

config = require('../config').config;

chars = ['', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'];

modetypelist = {
  "Html": 'html',
  "Css": 'css',
  "Javascript": 'javascript',
  "Jade": 'jade',
  "Less": 'less',
  "Coffeescript": 'coffee'
};

exports.before = function(req, res, next) {
  return next();
};

exports.room = function(req, res, next) {
  var rid;
  rid = req.params.room_id;
  if (rid.length !== 7) {
    return res.redirect('/');
  }
  req.session.roomname = rid;
  return res.render('room', {
    modetypelist: modetypelist
  });
};

exports.create = function(req, res, next) {
  var room_id;
  room_id = generateMixed(7);
  return res.redirect('/room/' + room_id);
};

generateMixed = function(n) {
  var i, res, _i;
  res = "";
  for (i = _i = 1; _i <= 7; i = ++_i) {
    res += chars[Math.ceil(Math.random() * (chars.length - 1))];
  }
  return res;
};