chai = require 'chai'
chai.should()
expect = chai.expect
path = require 'path'

proxyquire = require 'proxyquire'
childProcessProxy = require '../../fixtures/child-process-proxy'
CoverChildProcess = proxyquire '../../src/CoverChildProcess',
  'child_process': childProcessProxy

Instrumentation = require '../../mocks/Instrumentation'

describe 'CoverChildProcess', ->
  describe '#exec', ->
    it 'should exec the specified file with NodeJS, collect the coverage data as defined by the instrumentation and pass it back to be merged', (done) ->
      instrumentation = new Instrumentation()
      coverChildProcess = new CoverChildProcess instrumentation
      coverChildProcess.exec 'node ' + path.join(__dirname, '../../fixtures/test-exec'), {}, (error, stdout, stderr) ->
        expect(error).to.not.be.ok
        stdout.should.equal 'This is test output\n'
        stderr.should.equal ''
        instrumentation.data1.should.equal 'This is test data 1'
        instrumentation.data2.should.equal 'This is test data 2'
        done()

  describe '#spawn', ->
    it 'should spawn the specified file with NodeJS, collect the coverage data as defined by the instrumentation and pass it back to be merged', (done) ->
      instrumentation = new Instrumentation()
      coverChildProcess = new CoverChildProcess instrumentation
      child = coverChildProcess.spawn 'node', [path.join(__dirname, '../../fixtures/test-spawn')], {}
      child.stdout.on 'data', (data) ->
        child.kill()
      child.on 'exit', ->
        instrumentation.data1.should.equal 'This is test data 1'
        instrumentation.data2.should.equal 'This is test data 2'
        done()
