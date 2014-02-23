path = require 'path'

class Blanket
  constructor: (@_global) ->
    @_global = @_global || global

  collector: =>
    path.join __dirname, 'collectBlanket'

  merge: (data) =>
    if typeof @_global._$jscoverage == 'undefined'
      @_global._$jscoverage = {}
    jscoverage = @_global._$jscoverage
    sourceArrays = data.sourceArrays
    callCounts = data.callCounts
    mergeFile = (filename) =>
      dest = jscoverage[filename]
      src = callCounts[filename]
      if !dest
        dest = jscoverage[filename] = []
        dest.source = sourceArrays[filename]
      mergeCount = (count, index) =>
        if count
          if !dest[index] then dest[index] = 0
          dest[index] += count
      mergeCount count, index for count, index in src
    mergeFile filename for filename of sourceArrays

module.exports = Blanket