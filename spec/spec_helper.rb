require 'spec'

SPECDIR = File.dirname(__FILE__)

$LOAD_PATH.unshift(SPECDIR)
$LOAD_PATH.unshift(File.join(SPECDIR, '..', 'lib'))

# Make sure the binary is in our path
ENV['PATH'] = File.expand_path(File.join(SPECDIR, '..', 'bin')) + ':' + ENV['PATH']

require 'spectate'
# Get rid of the pre-set base directory, because we don't want to test on live configurations 
Spectate.send(:remove_const, :ROOT_DIR)
Spectate.const_set(:ROOT_DIR,nil)

require 'helpers/config_helpers'
require 'helpers/server_helpers'

Spec::Runner.configure do |config|
  
  # "And how do you take your coffee, Agent Cooper?"
  # "Black as midnight on a moonless night."
  config.mock_with :mocha
  
end
