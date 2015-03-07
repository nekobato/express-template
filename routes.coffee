express = require('express')
mongoose = require('mongoose')
path = require('path')
router = express.Router()

router.get "/", (req, res) ->
  dataModel = require path.resolve 'models/dataModel'
  res.render "index",
    title: "Express"
  return

module.exports = router
