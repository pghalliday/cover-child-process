chai = require 'chai'
chai.should()

CoverChildProcess = require '../../src/CoverChildProcess'
coverChildProcess = new CoverChildProcess 'blanket'

describe 'CoverChildProcess', ->
  describe '#exec', ->
    it 'should pass', ->
      true.should.be.true

  describe '#spawn', ->
    it 'should pass', ->
      true.should.be.true
