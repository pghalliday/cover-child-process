child_process = require 'child_process'
path = require 'path'
os = require 'os'
uuid = require 'uuid'
fs = require 'fs'

exec = child_process.exec
spawn = child_process.spawn

class ChildProcess
  constructor: (@instrumentation) ->

  exec: (command, options, callback) =>
    tokens = command.split ' '
    if tokens[0] == 'node'
      tokens.shift()
      tmpdir = os.tmpDir()
      tmpProxy = path.join tmpdir, uuid.v1()
      tmpData = path.join tmpdir, uuid.v1()
      # copy the proxy to a temp file so that it can be used recursively
      # (Although I think the only use case for this is in collecting coverage
      # data for itself - which only needs to be done in this project :))
      fs.writeFileSync tmpProxy, fs.readFileSync path.join __dirname, 'coverageProxy.js'
      commands = [
        'node'
        '"' + tmpProxy + '"'
        '"' + @instrumentation.collector() + '"'
        '"' + tmpData + '"'
      ].concat tokens
      exec commands.join(' '), options, (error, stdout, stderr) =>
        fs.unlinkSync tmpProxy
        if fs.existsSync tmpData
          @instrumentation.merge JSON.parse fs.readFileSync tmpData
          fs.unlinkSync tmpData
        callback error, stdout, stderr
    else
      exec command, options, callback

  spawn: (command, args, options) =>
    if command == 'node'
      tmpdir = os.tmpDir()
      tmpProxy = path.join tmpdir, uuid.v1()
      tmpData = path.join tmpdir, uuid.v1()
      # copy the proxy to a temp file so that it can be used recursively
      # (Although I think the only use case for this is in collecting coverage
      # data for itself - which only needs to be done in this project :))
      fs.writeFileSync tmpProxy, fs.readFileSync path.join __dirname, 'coverageProxy.js'
      newArgs = [
        tmpProxy
        @instrumentation.collector()
        tmpData
      ].concat args
      spawn(command, newArgs, options).on 'exit', =>
        fs.unlinkSync tmpProxy
        if fs.existsSync tmpData
          @instrumentation.merge JSON.parse fs.readFileSync tmpData
          fs.unlinkSync tmpData
    else
      spawn command, args, options

module.exports = ChildProcess