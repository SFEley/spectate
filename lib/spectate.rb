# Jump to the front of the line
$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'rubygems'
require 'spectate/config'

module Spectate
  autoload :Ping, 'spectate/ping'
  autoload :Server, 'spectate/server'
  # Set vital defaults
  VERSION = File.read(File.join(File.dirname(__FILE__), '..', 'VERSION')).chomp
  ROOT_DIR = File.expand_path(File.join('~','.spectate')) unless const_defined?(:ROOT_DIR)
  # Config['basedir'] = ENV['SPECTATE_DIR'] || File.expand_path(File.join('~','.spectate'))
end

