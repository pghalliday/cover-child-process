(function() {
  var chai, collect, expect, path;

  chai = require('chai');

  chai.should();

  expect = chai.expect;

  path = require('path');

  collect = require('../../mocks/collect');

  describe('collect', function() {
    return it('should return mock coverage data to be serialized as JSON', function() {
      global.data1 = 'This is test data 1';
      global.data2 = 'This is test data 2';
      return collect().should.eql({
        data1: 'This is test data 1',
        data2: 'This is test data 2'
      });
    });
  });

}).call(this);
