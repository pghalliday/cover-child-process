chai = require 'chai'
chai.should()

describe 'cover-child-process', ->
  describe '#exec', ->
    exec = require('../../src/index').exec

    it 'should pass', ->
      true.should.be.true

  describe '#spawn', ->
    spawn = require('../../src/index').spawn

    it 'should pass', ->
      true.should.be.true
