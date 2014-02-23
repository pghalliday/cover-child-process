cover-child-process
===================

[![Build Status](https://travis-ci.org/pghalliday/cover-child-process.png)](https://travis-ci.org/pghalliday/cover-child-process)
[![Coverage Status](https://coveralls.io/repos/pghalliday/cover-child-process/badge.png)](https://coveralls.io/r/pghalliday/cover-child-process)
[![Dependency Status](https://david-dm.org/pghalliday/cover-child-process.png?theme=shields.io)](https://david-dm.org/pghalliday/cover-child-process)
[![devDependency Status](https://david-dm.org/pghalliday/cover-child-process/dev-status.png?theme=shields.io)](https://david-dm.org/pghalliday/cover-child-process#info=devDependencies)

NPM module to collect coverage data from tests that need to spawn NodeJS child processes. Eg. end to end tests and/or tests on command line interfaces

Implements `spawn` and `exec` functions that wrap a target NodeJS script that has already been instrumented for coverage data, collects the coverage data and merges it with the coverage data already collected in the parent process.

Currently only supports files instrumented with [Blanket](https://www.npmjs.org/package/blanket). However, plugins for other similar instrumentation implementations can easily be created following the interface used for Blanket.

Usage
-----

Install and save to your `devDependencies`

```
npm install --save-dev cover-child-process
```

Use as you would the standard `child_process.exec` and `child_process.spawn` methods.

### #exec

```javascript
var ChildProcess = require('cover-child-process').ChildProcess;
var Blanket = require('cover-child-process').Blanket;

// Use the constructor to tell the library how the source has been instrumented
var childProcess = new ChildProcess(new Blanket());

var child = childProcess.exec(
  'node ../lib-cov/cli.js init something', {
    cwd: '../fixtures/test-scenario'
  }, function (error, stdout, stderr) {
    // Test output, etc, then done
  }
);
```

NB. If the command does not begin with `node` then it will be passed directly to `child_process` without capturing coverage data

### #spawn

```javascript
var ChildProcess = require('cover-child-process').ChildProcess;
var Blanket = require('cover-child-process').Blanket;

// Use the constructor to tell the library how the source has been instrumented
var childProcess = new ChildProcess(new Blanket());

var server = childProcess.spawn(
  'node', [
    '../lib-cov/server.js',
    '8080'
  ], {
    env: process.env
  }
);

server.stdout.on('data', function (data) {
  // When server has started run tests, then kill the child process
  server.kill();
});
```

NB. If the supplied command is not `node` then it will be passed directly to `child_process` without capturing coverage data

NNB. The spawned process must be killed with the default `SIGTERM` signal for the coverage data to be collected

License
-------

Copyright &copy; 2014 Peter Halliday  
Licensed under the MIT license.

[![Donate Bitcoins](https://coinbase.com/assets/buttons/donation_large-6ec72b1a9eec516944e50a22aca7db35.png)](https://coinbase.com/checkouts/9d121c0321590556b32241bbe7960362)
