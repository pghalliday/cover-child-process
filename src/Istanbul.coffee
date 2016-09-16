path = require 'path'

class Istanbul
  constructor: (@_global) ->
    @_global = @_global || global

  collector: =>
    path.join __dirname, 'collectIstanbul'

  merge: (data) =>
    if typeof @_global.__coverage__ == 'undefined'
      @_global.__coverage__ = {}
    coverage = @_global.__coverage__
    mergeFile = (filename) =>
      dest = coverage[filename]
      src = data[filename]
      if !dest
        dest = coverage[filename] = {}
        for prop of src
          if prop not in ['s', 'f', 'b']
            dest[prop] = src[prop]
      for prop in ['s', 'f']
        srclist = src[prop]
        destlist = dest[prop] = dest[prop] || {}
        for index of srclist
          destlist[index] = destlist[index] || 0
          destlist[index] += srclist[index]
      srcbranchlist = src['b']
      destbranchlist = dest['b'] = dest['b'] || {}
      for index of srcbranchlist
        destbranchlist[index] = destbranchlist[index] || [0, 0]
        destbranchlist[index][0] += srcbranchlist[index][0]
        destbranchlist[index][1] += srcbranchlist[index][1]
    mergeFile filename for filename of data

module.exports = Istanbul
