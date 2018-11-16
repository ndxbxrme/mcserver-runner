(function() {
  'use strict';
  var http, io, server, socketio, sockets;

  http = require('http');

  socketio = require('socket.io');

  server = http.createServer(function(req, res) {
    return console.log(req.url);
  }).listen(20007);

  sockets = [];

  io = socketio.listen(server);

  io.on('connection', function(socket) {
    console.log('got a connection');
    sockets.push(socket);
    return socket.on('disconnect', function() {
      return sockets.splice(sockets.indexOf(socket), 1);
    });
  });

}).call(this);

//# sourceMappingURL=index.js.map
