(function() {
  var ChildProcess, CoverChildProcess, Instrumentation, chai, childProcessProxy, expect, path, proxyquire;

  chai = require('chai');

  chai.should();

  expect = chai.expect;

  path = require('path');

  proxyquire = require('proxyquire');

  childProcessProxy = require('../../fixtures/child-process-proxy');

  CoverChildProcess = proxyquire('../../src/index', {
    'child_process': childProcessProxy
  });

  ChildProcess = CoverChildProcess.ChildProcess;

  Instrumentation = require('../../mocks/Instrumentation');

  describe('ChildProcess', function() {
    describe('#exec', function() {
      it('should exec the specified file with NodeJS, collect the coverage data as defined by the instrumentation and pass it back to be merged', function(done) {
        var childProcess, target;
        target = {};
        childProcess = new ChildProcess(new Instrumentation(target));
        return childProcess.exec('node ' + path.join(__dirname, '../../fixtures/test-exec'), {}, function(error, stdout, stderr) {
          expect(error).to.not.be.ok;
          stdout.should.equal('This is test output\n');
          stderr.should.equal('');
          target.data1.should.equal('This is test data 1');
          target.data2.should.equal('This is test data 2');
          return done();
        });
      });
      return it('should pass through none node commands to child_process', function(done) {
        var childProcess, target;
        target = {};
        childProcess = new ChildProcess(new Instrumentation(target));
        return childProcess.exec('pwd', {
          cwd: __dirname
        }, function(error, stdout, stderr) {
          expect(error).to.not.be.ok;
          stdout.should.equal(__dirname + '\n');
          stderr.should.equal('');
          return done();
        });
      });
    });
    return describe('#spawn', function() {
      it('should spawn the specified file with NodeJS, collect the coverage data as defined by the instrumentation and pass it back to be merged', function(done) {
        var child, childProcess, target;
        target = {};
        childProcess = new ChildProcess(new Instrumentation(target));
        child = childProcess.spawn('node', [path.join(__dirname, '../../fixtures/test-spawn')], {});
        child.stdout.on('data', function(data) {
          return child.kill();
        });
        return child.on('exit', function() {
          target.data1.should.equal('This is test data 1');
          target.data2.should.equal('This is test data 2');
          return done();
        });
      });
      return it('should pass through none node commands to child_process', function(done) {
        var child, childProcess, stdout, target;
        target = {};
        childProcess = new ChildProcess(new Instrumentation(target));
        child = childProcess.spawn('pwd', [], {
          cwd: __dirname
        });
        stdout = '';
        child.stdout.on('data', function(data) {
          return stdout += data;
        });
        return child.on('exit', function() {
          stdout.should.equal(__dirname + '\n');
          return done();
        });
      });
    });
  });

}).call(this);
