# Jump to the front of the line
$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'spectate/config'
require 'spectate/ping'
require 'spectate/server'

# Set vital defaults
Spectate::VERSION = File.read(File.join(File.dirname(__FILE__), '..', 'VERSION')).chomp
Spectate::Config['basedir'] = ENV['SPECTATE_DIR'] || File.expand_path(File.join('~','.spectate'))
