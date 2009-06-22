require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Spectate, "ping method" do
  include Spectate::Spec::ServerHelpers

  include Spectate::Ping
  
  it "returns nil if no Spectate server is running" do
    create_config
    ping.should be_nil
    remove_config
  end
  
  it "returns a Status object if a Spectate server is running" do
    start_server
    ping.should be_a_kind_of(Spectate::Status)
    stop_server
  end

end