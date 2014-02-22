cover-child-process
===================

[![Build Status](https://travis-ci.org/pghalliday/cover-child-process.png)](https://travis-ci.org/pghalliday/cover-child-process)
[![Coverage Status](https://coveralls.io/repos/pghalliday/cover-child-process/badge.png)](https://coveralls.io/r/pghalliday/cover-child-process)
[![Dependency Status](https://david-dm.org/pghalliday/cover-child-process.png?theme=shields.io)](https://david-dm.org/pghalliday/cover-child-process)
[![devDependency Status](https://david-dm.org/pghalliday/cover-child-process/dev-status.png?theme=shields.io)](https://david-dm.org/pghalliday/cover-child-process#info=devDependencies)

NPM module to collect coverage data from tests that need to spawn NodeJS child processes. Eg. end to end tests and/or tests on command line interfaces

Implements `spawn` and `exec` functions that wrap a target NodeJS script that has been instrumented for coverage data, collects the coverage data and merges it with the coverage data already collected in the parent process.

Currently only supports files instrumented with [Blanket](https://www.npmjs.org/package/blanket)

Usage
-----

Install and save to your `devDependencies`

```
npm install --save-dev cover-child-process
```

Use as you would the standard `child_process.exec` and `child_process.spawn`

### #exec

```javascript
var exec = require('cover-child-process').exec;

var child = exec(
  '../lib-cov/cli.js init something', {
    cwd: '../fixtures/test-scenario'
  }, function (error, stdout, stderr) {
    // Test output, etc, then done
  }
);
```

### #spawn

```javascript
var spawn = require('cover-child-process').spawn;

var server = spawn(
  '../lib-cov/server.js', [
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

License
-------

Copyright &copy; 2014 Peter Halliday  
Licensed under the MIT license.

[![Donate Bitcoins](https://coinbase.com/assets/buttons/donation_large-6ec72b1a9eec516944e50a22aca7db35.png)](https://coinbase.com/checkouts/9d121c0321590556b32241bbe7960362)
