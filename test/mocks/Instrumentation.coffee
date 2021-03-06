chai = require 'chai'
chai.should()
expect = chai.expect
path = require 'path'

Instrumentation = require '../../mocks/Instrumentation'

describe 'Instrumentation', ->
  it 'should start with no data recorded', ->
    instrumentation = new Instrumentation()
    expect(instrumentation.data1).to.not.be.ok
    expect(instrumentation.data2).to.not.be.ok

  describe '#collector', ->
    it 'should return the path to the collect module', ->
      instrumentation = new Instrumentation()
      instrumentation.collector().should.equal path.join __dirname, '../../mocks/collect'

  describe '#merge', ->
    it 'should record the data collected for merging on the supplied global object', ->
      target = {}
      instrumentation = new Instrumentation(target)
      instrumentation.merge
        data1: 'This is test data 1'
        data2: 'This is test data 2'
      target.data1.should.equal 'This is test data 1'
      target.data2.should.equal 'This is test data 2'
