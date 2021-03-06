cookieParser = require("cookie-parser")
bodyParser = require("body-parser")
express = require("express")
favicon = require("serve-favicon")
compass = require("node-compass")
logger = require("morgan")
path = require("path")
app = express()

pkg = require path.resolve 'package.json'

# optional
# mongoose = require('mongoose')
# mongoose.connect "mongodb://localhost/#{pkg.name}"
# redis = require('redis').createClient()

# app set
app.set "views", path.resolve 'views'
app.set "view engine", "jade"

# app use
app.use favicon path.resolve 'public/favicon.ico'
app.use logger "dev"
app.use bodyParser.json()
app.use bodyParser.urlencoded extended: false
app.use cookieParser()
app.use compass {mode: 'expanded'}
app.use express.static path.resolve 'public'
app.use '/', require path.resolve 'config/routes'


# catch 404 and forward to error handler
app.use (req, res, next) ->
  err = new Error("Not Found")
  err.status = 404
  next err
  return


# error handlers

# development error handler
# will print stacktrace
if app.get("env") is "development"
  app.use (err, req, res, next) ->
    res.status err.status or 500
    res.render "error",
      message: err.message
      error: err
    return


# production error handler
# no stacktraces leaked to user
app.use (err, req, res, next) ->
  res.status err.status or 500
  res.render "error",
    message: err.message
    error: {}
  return

module.exports = app
