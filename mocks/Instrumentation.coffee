path = require 'path'

class Instrumentation
  constructor: (@global) ->

  collector: =>
    path.join __dirname, 'collect'

  merge: (data) =>
    @global.data1 = data.data1
    @global.data2 = data.data2

module.exports = Instrumentation