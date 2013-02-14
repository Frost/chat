http     = require "http"
express  = require "express"
mongoose = require "mongoose"
Room     = require "./Room"
User     = require "./User"
color    = require "bash-color"

log = (err) ->
  console.error color.red err

module.exports = exports = (app, all) ->
  server = http.createServer app
  io     = require("socket.io").listen server

  io.sockets.on "connection", (socket) ->
    rooms =
      "Open": all
    user  = null

    socket.on "join", (name) ->
      Room.Model.findOne { name: name }, (err, room) ->
        return log err if err?
        rooms[name] = room
        socket.join name

    socket.on "leave", (name) ->
      delete rooms[name]
      socket.leave name

    socket.on "set", (data) ->
      console.log "setting user: ", data
      User.Model.create data, (err, doc) ->
        console.log err, doc, data
        user = doc

    socket.on "new", (data) ->
      return unless user?
      data.user = user.id
      room = new Room.Model data
      room.save (err) ->
        return log err if err?
        rooms[room.name] = room
        socket.join room.name

    socket.on "message", (data) ->
      msg = 
        at: new Date
        user: user?.name
        text: data.text
      socket.broadcast.emit "message", msg
      for name, room of rooms
        room.messages.push msg

  setInterval

  return server