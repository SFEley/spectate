require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Spectate, "ping method" do
  include Spectate::Ping
  
  it "returns nil if no Spectate server is running" do
    ping.should be_nil
  end
  
  it "returns a Status object if a Spectate server is running" do
    ping.should be_a_kind_of Spectate::Status
  end

  
end