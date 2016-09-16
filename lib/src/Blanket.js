(function() {
  var Blanket, path,
    bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  path = require('path');

  Blanket = (function() {
    function Blanket(_global) {
      this._global = _global;
      this.merge = bind(this.merge, this);
      this.collector = bind(this.collector, this);
      this._global = this._global || global;
    }

    Blanket.prototype.collector = function() {
      return path.join(__dirname, 'collectBlanket');
    };

    Blanket.prototype.merge = function(data) {
      var callCounts, filename, jscoverage, mergeFile, results, sourceArrays;
      if (typeof this._global._$jscoverage === 'undefined') {
        this._global._$jscoverage = {};
      }
      jscoverage = this._global._$jscoverage;
      sourceArrays = data.sourceArrays;
      callCounts = data.callCounts;
      mergeFile = (function(_this) {
        return function(filename) {
          var count, dest, i, index, len, mergeCount, results, src;
          dest = jscoverage[filename];
          src = callCounts[filename];
          if (!dest) {
            dest = jscoverage[filename] = [];
            dest.source = sourceArrays[filename];
          }
          mergeCount = function(count, index) {
            if (count) {
              if (!dest[index]) {
                dest[index] = 0;
              }
              return dest[index] += count;
            }
          };
          results = [];
          for (index = i = 0, len = src.length; i < len; index = ++i) {
            count = src[index];
            results.push(mergeCount(count, index));
          }
          return results;
        };
      })(this);
      results = [];
      for (filename in sourceArrays) {
        results.push(mergeFile(filename));
      }
      return results;
    };

    return Blanket;

  })();

  module.exports = Blanket;

}).call(this);
