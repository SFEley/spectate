BASEDIR = File.expand_path(File.join(File.dirname(__FILE__), '..', '..'))

$LOAD_PATH.unshift(BASEDIR + '/lib')

# Make sure the binary is in our path
ENV['PATH'] = BASEDIR + '/bin:' + ENV['PATH']

require 'spectate'

require 'spec/expectations'

require File.join(BASEDIR, 'spec', 'helpers', 'config_helpers')
World(Spectate::Spec::ConfigHelpers)

# Set up a config file that makes sense for us
Before do
  create_config
end

After do
  remove_config
end
  
  