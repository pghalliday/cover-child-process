chai = require 'chai'
chai.should()
expect = chai.expect
path = require 'path'

proxyquire = require 'proxyquire'
childProcessProxy = require '../../fixtures/child-process-proxy'
CoverChildProcess = proxyquire '../../src/index',
  'child_process': childProcessProxy
ChildProcess = CoverChildProcess.ChildProcess

Instrumentation = require '../../mocks/Instrumentation'

describe 'ChildProcess', ->
  describe '#exec', ->
    it 'should exec the specified file with NodeJS, collect the coverage data as defined by the instrumentation and pass it back to be merged', (done) ->
      target = {}
      childProcess = new ChildProcess new Instrumentation target
      childProcess.exec 'node ' + path.join(__dirname, '../../fixtures/test-exec'), {}, (error, stdout, stderr) ->
        expect(error).to.not.be.ok
        stdout.should.equal 'This is test output\n'
        stderr.should.equal ''
        target.data1.should.equal 'This is test data 1'
        target.data2.should.equal 'This is test data 2'
        done()

    it 'should pass through none node commands to child_process', (done) ->
      target = {}
      childProcess = new ChildProcess new Instrumentation target
      childProcess.exec 'pwd', {cwd: __dirname}, (error, stdout, stderr) ->
        expect(error).to.not.be.ok
        stdout.should.equal __dirname + '\n'
        stderr.should.equal ''
        done()

  describe '#spawn', ->
    it 'should spawn the specified file with NodeJS, collect the coverage data as defined by the instrumentation and pass it back to be merged', (done) ->
      target = {}
      childProcess = new ChildProcess new Instrumentation target
      child = childProcess.spawn 'node', [path.join(__dirname, '../../fixtures/test-spawn')], {}
      child.stdout.on 'data', (data) ->
        child.kill()
      child.on 'exit', ->
        target.data1.should.equal 'This is test data 1'
        target.data2.should.equal 'This is test data 2'
        done()

    it 'should pass through none node commands to child_process', (done) ->
      target = {}
      childProcess = new ChildProcess new Instrumentation target
      child = childProcess.spawn 'pwd', [], {cwd: __dirname}
      stdout = ''
      child.stdout.on 'data', (data) ->
        stdout += data
      child.on 'exit', ->
        stdout.should.equal __dirname + '\n'
        done()
