chai = require 'chai'
chai.should()
expect = chai.expect
path = require 'path'

collect = require '../../mocks/collect'

describe 'collect', ->
  it 'should return mock coverage data to be serialized as JSON', ->
    global.data1 = 'This is test data 1'
    global.data2 = 'This is test data 2'
    collect().should.eql
      data1: 'This is test data 1'
      data2: 'This is test data 2'
