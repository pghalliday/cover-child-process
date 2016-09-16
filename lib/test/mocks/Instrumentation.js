(function() {
  var Instrumentation, chai, expect, path;

  chai = require('chai');

  chai.should();

  expect = chai.expect;

  path = require('path');

  Instrumentation = require('../../mocks/Instrumentation');

  describe('Instrumentation', function() {
    it('should start with no data recorded', function() {
      var instrumentation;
      instrumentation = new Instrumentation();
      expect(instrumentation.data1).to.not.be.ok;
      return expect(instrumentation.data2).to.not.be.ok;
    });
    describe('#collector', function() {
      return it('should return the path to the collect module', function() {
        var instrumentation;
        instrumentation = new Instrumentation();
        return instrumentation.collector().should.equal(path.join(__dirname, '../../mocks/collect'));
      });
    });
    return describe('#merge', function() {
      return it('should record the data collected for merging on the supplied global object', function() {
        var instrumentation, target;
        target = {};
        instrumentation = new Instrumentation(target);
        instrumentation.merge({
          data1: 'This is test data 1',
          data2: 'This is test data 2'
        });
        target.data1.should.equal('This is test data 1');
        return target.data2.should.equal('This is test data 2');
      });
    });
  });

}).call(this);
