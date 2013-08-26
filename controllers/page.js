var config = require('../config').config; 

exports.before = function(req,res, next) { 
  // var user = db.users[req.params.user_id];
  // if (!user) { return next(); }
  next();
};
exports.homepage = function(req,res, next) {
  res.render('homepage');
}