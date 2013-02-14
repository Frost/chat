express   = require "express"
mongoose  = require "mongoose"
Room      = require "./Room"
User      = require "./User"
fibrous   = require "fibrous"
# highlight = require "highlight.js"
color     = require "bash-color"
fs        = require "fs"

require "express-mongoose"

app = do express
app.configure ->
  # Setup view Engine
  app.set "views", "#{__dirname}/views"
  app.set "view engine", "jade"

  # Set the public folder as static assets
  app.use express.static "#{__dirname}/public"

  # Set up middleware
  app.use require("express-jquery") "/javascript/jquery.js"
  app.use fibrous.middleware

  # Handle root
  app.get "/", (req, res) ->
    # res.set "Content-Type": "application/xhtml+xml; charset=utf-8"
    res.render "index"
      title: "ChatZone"
      rooms: Room.Model.find { private: false }

  # Handle source coffeescript
  app.get "/coffeescript/:script", (req, res) ->
    path = req.params.script.replace ".js", ""
    try
      res.render "coffee"
        title: path
        source: fs.sync.readFile "#{__dirname}/client/#{path}.coffee", "utf-8"
    catch e
      res.send 404, "No such file"

# Debug and logging
app.configure "development", ->
  app.use require("express-error").express3
    contextLinesCount: 3
    handleUncaughtException: true

mongoose.connect "mongodb://localhost/chat"
mongodb = mongoose.connection;
mongodb.on "error", (err) ->
  console.error "Connection error: ", color.red err

findOrCreate = (model, data, cb) ->
  model.findOne { name: data.name }, (err, doc) ->
    if err?
      model.create doc, cb
    else
      cb null, data

prepare = fibrous ->
  User.Model.sync.remove {}
  Room.Model.sync.remove {}
  server = findOrCreate.sync User.Model,
    name: "Server"
  first = findOrCreate.sync Room.Model,
    owner: server.id
    name: "First"
    messages: []
  test = findOrCreate.sync Room.Model,
    owner: server.id
    name: "Test"
    messages: []
  open = findOrCreate.sync Room.Model,
    owner: server.id
    name: "Open"
    messages: []
    private: false
  console.log server.id
  return open
mongodb.once "open", -> prepare (err, all) ->
  console.log err.stack if err?
  server = require("./api") app, all

  # Define port and start Server
  port = process.env.PORT or process.env.VMC_APP_PORT or 3000
  server.listen port, -> console.log "Listening on #{port}\nPress CTRL-C to stop server."