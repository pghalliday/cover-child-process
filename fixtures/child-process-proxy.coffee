child_process = require 'child_process'
exec = child_process.exec
spawn = child_process.spawn

InstrumentationBlanket = require './InstrumentationBlanket'
CoverChildProcess = require '../src/CoverChildProcess'
coverChildProcess = new CoverChildProcess new InstrumentationBlanket

child_process.exec = (command, options, callback) ->
  coverChildProcess.exec command, options, callback

child_process.spawn = (command, args, options) ->
  coverChildProcess.spawn command, args, options

module.exports = child_process
