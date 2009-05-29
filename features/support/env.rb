$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../../lib')

# Make sure the binary is in our path
ENV['PATH'] = File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'bin')) + ':' + ENV['PATH']

require 'spectate'

require 'spec/expectations'
