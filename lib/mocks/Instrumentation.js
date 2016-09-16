(function() {
  var Instrumentation, path,
    bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  path = require('path');

  Instrumentation = (function() {
    function Instrumentation(global) {
      this.global = global;
      this.merge = bind(this.merge, this);
      this.collector = bind(this.collector, this);
    }

    Instrumentation.prototype.collector = function() {
      return path.join(__dirname, 'collect');
    };

    Instrumentation.prototype.merge = function(data) {
      this.global.data1 = data.data1;
      return this.global.data2 = data.data2;
    };

    return Instrumentation;

  })();

  module.exports = Instrumentation;

}).call(this);
