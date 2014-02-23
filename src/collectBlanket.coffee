module.exports = (_global) ->
  _global = _global || global
  data =
    sourceArrays: {}
    callCounts: {}
  jscoverage = _global._$jscoverage
  if jscoverage
    # we have to create our own structure as the _$jscoverage
    # structure does not stringify to JSON fully as it skips
    # the source property that is added to the array
    record = (filename) ->
      data.sourceArrays[filename] = jscoverage[filename].source;
      data.callCounts[filename] = jscoverage[filename];
    record filename for filename of jscoverage
  data
