(function() {
  module.exports = function(_global) {
    var data, filename, jscoverage, record;
    _global = _global || global;
    data = {
      sourceArrays: {},
      callCounts: {}
    };
    jscoverage = _global._$jscoverage;
    if (jscoverage) {
      record = function(filename) {
        data.sourceArrays[filename] = jscoverage[filename].source;
        return data.callCounts[filename] = jscoverage[filename];
      };
      for (filename in jscoverage) {
        record(filename);
      }
    }
    return data;
  };

}).call(this);
