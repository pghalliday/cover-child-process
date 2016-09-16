(function() {
  var Blanket, chai;

  chai = require('chai');

  chai.should();

  Blanket = require('../../src/index').Blanket;

  describe('Blanket', function() {
    it('should merge collected Blanket coverage data with the coverage data on the global object', function() {
      var blanket, collect, data, expectedData, globalData, mergeData;
      globalData = {
        _$jscoverage: {
          'file1': [],
          'file2': []
        }
      };
      globalData._$jscoverage['file1'].source = 'source1';
      globalData._$jscoverage['file1'][5] = 10;
      globalData._$jscoverage['file1'][18] = 20;
      globalData._$jscoverage['file2'].source = 'source2';
      globalData._$jscoverage['file2'][3] = 15;
      globalData._$jscoverage['file2'][20] = 27;
      blanket = new Blanket(globalData);
      mergeData = {
        _$jscoverage: {
          'file1': [],
          'file3': []
        }
      };
      mergeData._$jscoverage['file1'].source = 'source1';
      mergeData._$jscoverage['file1'][10] = 7;
      mergeData._$jscoverage['file1'][18] = 5;
      mergeData._$jscoverage['file3'].source = 'source3';
      mergeData._$jscoverage['file3'][3] = 5;
      mergeData._$jscoverage['file3'][15] = 4;
      collect = require(blanket.collector());
      data = collect(mergeData);
      blanket.merge(JSON.parse(JSON.stringify(data)));
      expectedData = {
        _$jscoverage: {
          'file1': [],
          'file2': [],
          'file3': []
        }
      };
      expectedData._$jscoverage['file1'].source = 'source1';
      expectedData._$jscoverage['file1'][5] = 10;
      expectedData._$jscoverage['file1'][10] = 7;
      expectedData._$jscoverage['file1'][18] = 25;
      expectedData._$jscoverage['file2'].source = 'source2';
      expectedData._$jscoverage['file2'][3] = 15;
      expectedData._$jscoverage['file2'][20] = 27;
      expectedData._$jscoverage['file3'].source = 'source3';
      expectedData._$jscoverage['file3'][3] = 5;
      expectedData._$jscoverage['file3'][15] = 4;
      return globalData.should.eql(expectedData);
    });
    return it('should add collected Blanket coverage data if there is no coverage data on the global object', function() {
      var blanket, collect, data, expectedData, globalData, mergeData;
      globalData = {};
      blanket = new Blanket(globalData);
      mergeData = {
        _$jscoverage: {
          'file1': [],
          'file3': []
        }
      };
      mergeData._$jscoverage['file1'].source = 'source1';
      mergeData._$jscoverage['file1'][10] = 7;
      mergeData._$jscoverage['file1'][18] = 5;
      mergeData._$jscoverage['file3'].source = 'source3';
      mergeData._$jscoverage['file3'][3] = 5;
      mergeData._$jscoverage['file3'][15] = 4;
      collect = require(blanket.collector());
      data = collect(mergeData);
      blanket.merge(JSON.parse(JSON.stringify(data)));
      expectedData = {
        _$jscoverage: {
          'file1': [],
          'file3': []
        }
      };
      expectedData._$jscoverage['file1'].source = 'source1';
      expectedData._$jscoverage['file1'][10] = 7;
      expectedData._$jscoverage['file1'][18] = 5;
      expectedData._$jscoverage['file3'].source = 'source3';
      expectedData._$jscoverage['file3'][3] = 5;
      expectedData._$jscoverage['file3'][15] = 4;
      return globalData.should.eql(expectedData);
    });
  });

}).call(this);
