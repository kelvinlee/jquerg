var page = require('./controllers/page');  
var room = require('./controllers/room');  

module.exports = function (app) {
  // git never changed.
  // home page
  app.get('/', page.homepage);
  app.get('/room', room.create);
  app.get('/room/:room_id', room.room);
  
  
  // art 
  // app.get('/arts/:page_id', art.list);
  // app.get('/art/:art_id', art.show);
  // app.get('/newart', art.create);
   
  // // user
  // app.get('/reg', user.reg);
  // app.get('/logout', user.logout);
  
  // // user post
  // app.post('/user', user.create);
  // app.post('/login', user.login);


  //art post
  // app.post('/art/:art_id',art.createblog);
};
console.log("routes loaded.");