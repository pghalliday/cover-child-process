chai = require 'chai'
chai.should()

CoverChildProcess = require '../../src/CoverChildProcess'

describe 'CoverChildProcess', ->
  describe '#exec', ->
    it 'should pass', ->
      coverageData = {}
      coverChildProcess = new CoverChildProcess 
        instrumentation: 'blanket'
        coverageData: coverageData
      true.should.be.true

  describe '#spawn', ->
    it 'should pass', ->
      coverageData = {}
      coverChildProcess = new CoverChildProcess 
        instrumentation: 'blanket'
        coverageData: coverageData
      true.should.be.true
