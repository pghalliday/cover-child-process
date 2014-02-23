child_process = require 'child_process'
exec = child_process.exec
spawn = child_process.spawn

Blanket = require('../src/index').Blanket
ChildProcess = require('../src/index').ChildProcess
childProcess = new ChildProcess new Blanket global

child_process.exec = (command, options, callback) ->
  childProcess.exec command, options, callback

child_process.spawn = (command, args, options) ->
  childProcess.spawn command, args, options

module.exports = child_process
