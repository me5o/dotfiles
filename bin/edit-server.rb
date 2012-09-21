#!/usr/bin/ruby
require 'webrick'
require 'tempfile'

$EDITOR = '/Applications/MacVim.app/Contents/MacOS/Vim'
$PORT = 9292

server = WEBrick::HTTPServer.new(:Port => $PORT)

trap('INT') { server.shutdown }

server.mount_proc('/status') do |req, res|
  res.status = 200
end

server.mount_proc('/edit') do |req, res|
  temp = Tempfile.new('editwith_')
  temp << req.body
  temp.close false
  system $EDITOR, "-g", "-f", temp.path
  temp.open
  res.body = temp.read
  temp.close
  res.status = 200
  res['Content-Type'] = 'text/plain'
  res['Content-Length'] = res.body.size
end

server.start
