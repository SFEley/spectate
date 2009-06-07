require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'net/http'

describe Spectate::Server do
  include Spectate::Spec::ServerHelpers
  before(:all) do
    puts start_server
  end
  it "responds to GET" do
    response = Net::HTTP.get_response('localhost','/',47502)
    response.code.should == 200
  end
  
  it "responds to a GET with its name and version number" do
    response = Net::HTTP.get_response('localhost','/',47502)
    response.message.should =~ /Spectate v#{Spectate::VERSION}/
  end
  after(:all) do
    stop_server
  end
end