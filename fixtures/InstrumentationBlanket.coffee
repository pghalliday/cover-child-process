path = require 'path'

class InstrumentationBlanket
  constructor: ->

  collector: =>
    path.join __dirname, 'collectBlanket'

  merge: (data) =>
    if typeof global._$jscoverage == 'undefined'
      global._$jscoverage = {}
    jscoverage = global._$jscoverage
    sourceArrays = data.sourceArrays
    callCounts = data.callCounts
    mergeFile = (filename) =>
      dest = jscoverage[filename]
      src = callCounts[filename]
      src.source = sourceArrays[filename]
      if typeof dest == 'undefined'
        jscoverage[filename] = src
      else
        mergeCount = (count, index) =>
          if count != null
            dest[index] += count
        mergeCount count, index for count, index in src
    mergeFile filename for filename of sourceArrays

module.exports = InstrumentationBlanket