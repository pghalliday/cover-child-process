(function() {
  var Blanket, ChildProcess, childProcess, child_process, exec, spawn;

  child_process = require('child_process');

  exec = child_process.exec;

  spawn = child_process.spawn;

  Blanket = require('../src/index').Blanket;

  ChildProcess = require('../src/index').ChildProcess;

  childProcess = new ChildProcess(new Blanket(global));

  child_process.exec = function(command, options, callback) {
    return childProcess.exec(command, options, callback);
  };

  child_process.spawn = function(command, args, options) {
    return childProcess.spawn(command, args, options);
  };

  module.exports = child_process;

}).call(this);
