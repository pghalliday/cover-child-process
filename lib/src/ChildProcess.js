(function() {
  var ChildProcess, child_process, exec, fs, os, path, spawn, uuid,
    bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  child_process = require('child_process');

  path = require('path');

  os = require('os');

  uuid = require('uuid');

  fs = require('fs');

  exec = child_process.exec;

  spawn = child_process.spawn;

  ChildProcess = (function() {
    function ChildProcess(instrumentation) {
      this.instrumentation = instrumentation;
      this.spawn = bind(this.spawn, this);
      this.exec = bind(this.exec, this);
    }

    ChildProcess.prototype.exec = function(command, options, callback) {
      var commands, tmpData, tmpProxy, tmpdir, tokens;
      tokens = command.split(' ');
      if (tokens[0] === 'node') {
        tokens.shift();
        tmpdir = os.tmpDir();
        tmpProxy = path.join(tmpdir, uuid.v1());
        tmpData = path.join(tmpdir, uuid.v1());
        fs.writeFileSync(tmpProxy, fs.readFileSync(path.join(__dirname, 'coverageProxy.js')));
        commands = ['node', '"' + tmpProxy + '"', '"' + this.instrumentation.collector() + '"', '"' + tmpData + '"'].concat(tokens);
        return exec(commands.join(' '), options, (function(_this) {
          return function(error, stdout, stderr) {
            fs.unlinkSync(tmpProxy);
            if (fs.existsSync(tmpData)) {
              _this.instrumentation.merge(JSON.parse(fs.readFileSync(tmpData)));
              fs.unlinkSync(tmpData);
            }
            return callback(error, stdout, stderr);
          };
        })(this));
      } else {
        return exec(command, options, callback);
      }
    };

    ChildProcess.prototype.spawn = function(command, args, options) {
      var newArgs, tmpData, tmpProxy, tmpdir;
      if (command === 'node') {
        tmpdir = os.tmpDir();
        tmpProxy = path.join(tmpdir, uuid.v1());
        tmpData = path.join(tmpdir, uuid.v1());
        fs.writeFileSync(tmpProxy, fs.readFileSync(path.join(__dirname, 'coverageProxy.js')));
        newArgs = [tmpProxy, this.instrumentation.collector(), tmpData].concat(args);
        return spawn(command, newArgs, options).on('exit', (function(_this) {
          return function() {
            fs.unlinkSync(tmpProxy);
            if (fs.existsSync(tmpData)) {
              _this.instrumentation.merge(JSON.parse(fs.readFileSync(tmpData)));
              return fs.unlinkSync(tmpData);
            }
          };
        })(this));
      } else {
        return spawn(command, args, options);
      }
    };

    return ChildProcess;

  })();

  module.exports = ChildProcess;

}).call(this);
