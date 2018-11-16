'use strict'

http = require 'http'
socketio = require 'socket.io'
{spawn} = require 'child_process'
{streamWrite, streamEnd, onExit} = require '@rauschma/stringio'

mcserverRunning = false
ssh = null
server = http.createServer (req, res) ->
  console.log req.url
.listen 20007
sockets = []
emit = (name, data) ->
  for socket in sockets
    socket.emit name, data
io = socketio.listen server
io.on 'connection', (socket) ->
  console.log 'got a connection'
  sockets.push socket
  socket.on 'disconnect', ->
    sockets.splice sockets.indexOf(socket), 1
  socket.on 'command', (data) ->
    await streamWrite ssh.stdin, data + '\n'

start = ->
  args = "-Xmx2048M -Xms2048M -jar server.jar nogui".split(/ /g)
  ssh = spawn 'java', args,
    cwd: '/Users/kieronwright/Minecraft'
    stdio: [
      'pipe'
      'pipe'
      process.stderr
    ]
  ssh.stdout.on 'data', (data) ->
    udata = data.toString('utf8')
    if not mcserverRunning
      mcserverRunning = /^Done/.test udata
    console.log udata
    emit 'data', udata
start()