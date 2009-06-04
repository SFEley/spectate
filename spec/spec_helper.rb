require 'spec'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

# Make sure the binary is in our path
ENV['PATH'] = File.expand_path(File.join(File.dirname(__FILE__), '..', 'bin')) + ':' + ENV['PATH']

require 'spectate'

Spec::Runner.configure do |config|
  
  # "And how do you take your coffee, Agent Cooper?"
  # "Black as midnight on a moonless night."
  config.mock_with :mocha
  
end
