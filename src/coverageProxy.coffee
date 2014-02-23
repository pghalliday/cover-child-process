collector = process.argv[2]
output = process.argv[3]
module = process.argv[4]

# remove this script, the collector module path and the output file name from the argv array
process.argv.splice 1, 3

process.on 'exit', ->
  require('fs').writeFileSync output, JSON.stringify require(require('path').resolve(collector))()

# need to handle SIGTERM in order to fire the exit event using process.exit
# otherwise the process will exit without firing the exit event :s
process.on 'SIGTERM', ->
  process.exit()

# require the module we are proxying but resolve the path relative to CWD
# instead of the default require behaviour of relative to this module
require require('path').resolve module
