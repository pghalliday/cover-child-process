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

    it 'should error if a none node command is supplied', (done) ->
      target = {}
      childProcess = new ChildProcess new Instrumentation target
      childProcess.exec 'notnode', {}, (error, stdout, stderr) ->
        expect(error).to.eql new Error 'Only node processes are supported'
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

    it 'should throw an error if a none node command is supplied', ->
      target = {}
      childProcess = new ChildProcess new Instrumentation target
      expect(childProcess.spawn.bind childProcess, 'notnode', [], {}).to.throw 'Only node processes are supported'
