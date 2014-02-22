path = require 'path'

class Instrumentation
  constructor: ->

  collector: =>
    path.join __dirname, 'collect'

  merge: (data) =>
    this.data1 = data.data1
    this.data2 = data.data2

module.exports = Instrumentation