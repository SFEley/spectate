require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'spectate/client'

describe Spectate::Client do
  include Spectate::Spec::ServerHelpers
  
  before(:all) do
    start_server
  end
  describe "configuration" do
    it "loads configuration if it has to" do
      Spectate::Config.clear!
      Spectate::Config.expects(:load_configuration).returns(true)
      @this = Spectate::Client.new
    end
  
    it "doesn't reload the configuration if it doesn't have to" do
      Spectate::Config.expects(:load_configuration).never
      Spectate::Config.expects(:loaded?).returns(true)
      @this = Spectate::Client.new
    end
    
    it "knows its host" do
      @this = Spectate::Client.new
      @this.host.should == 'localhost'
    end
  
    it "can override its host on creation" do
      @this = Spectate::Client.new(:host => 'example.com')
      @this.host.should == 'example.com'
    end
  
    it "can override its host at any time" do
      @this = Spectate::Client.new
      @this.host = 'example.org'
      @this.host.should == 'example.org'
    end
  
    it "knows its port" do
      @this = Spectate::Client.new
      @this.port.should == 47502
    end
  
    it "can override its port on creation" do
      @this = Spectate::Client.new(:port => 8888)
      @this.port.should == 8888
    end
  
    it "can override its port at any time" do
      @this = Spectate::Client.new
      @this.port = 9999
      @this.port.should == 9999
    end

    it "knows its protocol" do
      @this = Spectate::Client.new
      @this.protocol.should == 'http'
    end
  
    it "can override its protocol on creation" do
      @this = Spectate::Client.new(:protocol => 'https')
      @this.protocol.should == 'https'
    end
  
    it "can override its protocol at any time" do
      @this = Spectate::Client.new
      @this.protocol = 'ftp'
      @this.protocol.should == 'ftp'
    end

    it "defaults to accepting JSON" do
      @this = Spectate::Client.new
      @this.accept.should == 'application/json'
    end

    it "can override its accept on creation" do
      @this = Spectate::Client.new(:accept => 'text/html')
      @this.accept.should == 'text/html'
    end

    it "can override its accept at any time" do
      @this = Spectate::Client.new
      @this.accept = 'application/xml'
      @this.accept.should == 'application/xml'
    end
    
    it "knows its root with a port" do
      @this = Spectate::Client.new(:protocol => 'https', :host => 'example.org', :port => 777)
      @this.root.should == 'https://example.org:777'
    end
    
    it "knows its root without a port or protocol" do
      @this = Spectate::Client.new(:host => '10.0.1.5', :port => 0)
      @this.root.should == 'http://10.0.1.5'
    end
    
  end
  
  shared_examples_for "a Rest-Client proxy method" do
    STATUS_JSON = '{"data":{"uptime":"23h 14m 11s","summary":"Spectate v0.0.0.0"},"json_class":"Spectate::Status"}'
    before(:each) do
      method = @method
      @dummy = stub('Rest Client') do
        stubs(method).returns(STATUS_JSON)
        stubs(:[]).returns(@dummy)
      end
      @this.instance_variable_set(:@driver, @dummy)
    end
    it "calls the method in the RestClient resource" do
      @dummy.expects(@method).returns(STATUS_JSON)
      @this.send(@method).should_not be_nil
    end
    it "parses the result when accepting JSON" do
      @this.send(@method).should be_a_kind_of(Spectate::Status)
    end
    it "includes the appropriate fields" do
      s = @this.send(@method)
      s[:summary].should =~ /Spectate/
    end
    it "returns nil on a Resource Not Found error" do
      @dummy.expects(@method).raises(RestClient::ResourceNotFound)
      @this.send(@method).should be_nil
    end
    it "raises any other exception" do
      @dummy.expects(@method).raises(RestClient::RequestFailed)
      lambda{@this.send(@method)}.should raise_error(RestClient::RequestFailed)
    end
  end
  
  describe 'calling method' do
    before(:each) do
      @this = Spectate::Client.new
    end
    
    describe "get" do
      before(:each) do
        @method = :get
      end
      it_should_behave_like "a Rest-Client proxy method"
    end
  end
  
  after(:all) do
    stop_server
  end
end