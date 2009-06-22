# Spectate lives wherever this config.ru file lives.
module Spectate
  ROOT_DIR = File.expand_path(File.dirname(__FILE__))
end

# If you're developing or customizing Spectate, you can create a 'src'
# directory and it'll load Spectate from here instead of the gem. If you want to
# use your own projects directory instead, make a symlink. (If you don't know
# how to do THAT, you probably shouldn't be developing or customizing Spectate.)
if File.exists?(File.join(Spectate::ROOT_DIR, 'src'))
  SOURCE_DIR = File.join(Spectate::ROOT_DIR, 'src')
  require File.join(SOURCE_DIR, 'lib', 'spectate')
else
  require 'rubygems'
  require 'spectate'  
end

# Make the magic happen
run Spectate::Server
