(function() {
  var Istanbul, chai;

  chai = require('chai');

  chai.should();

  Istanbul = require('../../src/index').Istanbul;

  describe('Istanbul', function() {
    it('should merge collected Istanbul coverage data with the coverage data on the global object', function() {
      var collect, data, expectedData, globalData, istanbul, mergeData;
      globalData = {
        __coverage__: {
          file1: {
            otherProperty: 'hello',
            s: {
              '1': 1,
              '2': 2,
              '3': 3
            },
            b: {
              '1': [1, 2],
              '2': [2, 3],
              '3': [3, 4]
            },
            f: {
              '1': 1,
              '2': 2,
              '3': 3
            }
          },
          file2: {
            otherProperty: 'boo',
            s: {
              '1': 2,
              '2': 4,
              '3': 3
            },
            b: {
              '1': [2, 5],
              '2': [1, 2],
              '3': [3, 2]
            },
            f: {
              '1': 3,
              '2': 1,
              '3': 8
            }
          }
        }
      };
      istanbul = new Istanbul(globalData);
      mergeData = {
        __coverage__: {
          file1: {
            otherProperty: 'hello',
            s: {
              '1': 2,
              '2': 3,
              '3': 4
            },
            b: {
              '1': [2, 3],
              '2': [3, 4],
              '3': [4, 5]
            },
            f: {
              '1': 2,
              '2': 3,
              '3': 4
            }
          },
          file2: {
            otherProperty: 'boo',
            s: {
              '1': 3,
              '2': 5,
              '3': 4
            },
            b: {
              '1': [3, 6],
              '2': [2, 3],
              '3': [4, 3]
            },
            f: {
              '1': 4,
              '2': 2,
              '3': 9
            }
          }
        }
      };
      collect = require(istanbul.collector());
      data = collect(mergeData);
      istanbul.merge(JSON.parse(JSON.stringify(data)));
      expectedData = {
        __coverage__: {
          file1: {
            otherProperty: 'hello',
            s: {
              '1': 3,
              '2': 5,
              '3': 7
            },
            b: {
              '1': [3, 5],
              '2': [5, 7],
              '3': [7, 9]
            },
            f: {
              '1': 3,
              '2': 5,
              '3': 7
            }
          },
          file2: {
            otherProperty: 'boo',
            s: {
              '1': 5,
              '2': 9,
              '3': 7
            },
            b: {
              '1': [5, 11],
              '2': [3, 5],
              '3': [7, 5]
            },
            f: {
              '1': 7,
              '2': 3,
              '3': 17
            }
          }
        }
      };
      return globalData.should.eql(expectedData);
    });
    return it('should add collected Istanbul coverage data if there is no coverage data on the global object', function() {
      var collect, data, expectedData, globalData, istanbul, mergeData;
      globalData = {};
      istanbul = new Istanbul(globalData);
      mergeData = {
        __coverage__: {
          file1: {
            otherProperty: 'hello',
            s: {
              '1': 1,
              '2': 2,
              '3': 3
            },
            b: {
              '1': [1, 2],
              '2': [2, 3],
              '3': [3, 4]
            },
            f: {
              '1': 1,
              '2': 2,
              '3': 3
            }
          },
          file2: {
            otherProperty: 'boo',
            s: {
              '1': 2,
              '2': 4,
              '3': 3
            },
            b: {
              '1': [2, 5],
              '2': [1, 2],
              '3': [3, 2]
            },
            f: {
              '1': 3,
              '2': 1,
              '3': 8
            }
          }
        }
      };
      collect = require(istanbul.collector());
      data = collect(mergeData);
      istanbul.merge(JSON.parse(JSON.stringify(data)));
      expectedData = {
        __coverage__: {
          file1: {
            otherProperty: 'hello',
            s: {
              '1': 1,
              '2': 2,
              '3': 3
            },
            b: {
              '1': [1, 2],
              '2': [2, 3],
              '3': [3, 4]
            },
            f: {
              '1': 1,
              '2': 2,
              '3': 3
            }
          },
          file2: {
            otherProperty: 'boo',
            s: {
              '1': 2,
              '2': 4,
              '3': 3
            },
            b: {
              '1': [2, 5],
              '2': [1, 2],
              '3': [3, 2]
            },
            f: {
              '1': 3,
              '2': 1,
              '3': 8
            }
          }
        }
      };
      return globalData.should.eql(expectedData);
    });
  });

}).call(this);
