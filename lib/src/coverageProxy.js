(function() {
  var collector, module, output;

  collector = process.argv[2];

  output = process.argv[3];

  module = process.argv[4];

  process.argv.splice(1, 3);

  process.on('exit', function() {
    return require('fs').writeFileSync(output, JSON.stringify(require(require('path').resolve(collector))()));
  });

  process.on('SIGTERM', function() {
    return process.exit();
  });

  require(require('path').resolve(module));

}).call(this);
