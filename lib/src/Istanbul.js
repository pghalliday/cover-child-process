(function() {
  var Istanbul, path,
    bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  path = require('path');

  Istanbul = (function() {
    function Istanbul(_global) {
      this._global = _global;
      this.merge = bind(this.merge, this);
      this.collector = bind(this.collector, this);
      this._global = this._global || global;
    }

    Istanbul.prototype.collector = function() {
      return path.join(__dirname, 'collectIstanbul');
    };

    Istanbul.prototype.merge = function(data) {
      var coverage, filename, mergeFile, results;
      if (typeof this._global.__coverage__ === 'undefined') {
        this._global.__coverage__ = {};
      }
      coverage = this._global.__coverage__;
      mergeFile = (function(_this) {
        return function(filename) {
          var dest, destbranchlist, destlist, i, index, len, prop, ref, results, src, srcbranchlist, srclist;
          dest = coverage[filename];
          src = data[filename];
          if (!dest) {
            dest = coverage[filename] = {};
            for (prop in src) {
              if (prop !== 's' && prop !== 'f' && prop !== 'b') {
                dest[prop] = src[prop];
              }
            }
          }
          ref = ['s', 'f'];
          for (i = 0, len = ref.length; i < len; i++) {
            prop = ref[i];
            srclist = src[prop];
            destlist = dest[prop] = dest[prop] || {};
            for (index in srclist) {
              destlist[index] = destlist[index] || 0;
              destlist[index] += srclist[index];
            }
          }
          srcbranchlist = src['b'];
          destbranchlist = dest['b'] = dest['b'] || {};
          results = [];
          for (index in srcbranchlist) {
            destbranchlist[index] = destbranchlist[index] || [0, 0];
            destbranchlist[index][0] += srcbranchlist[index][0];
            results.push(destbranchlist[index][1] += srcbranchlist[index][1]);
          }
          return results;
        };
      })(this);
      results = [];
      for (filename in data) {
        results.push(mergeFile(filename));
      }
      return results;
    };

    return Istanbul;

  })();

  module.exports = Istanbul;

}).call(this);
