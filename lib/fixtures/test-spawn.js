(function() {
  global.data1 = "This is test data 1";

  global.data2 = "This is test data 2";

  console.log("This is test output");

  setInterval(function() {
    return console.log("This is test output");
  }, 100);

}).call(this);
