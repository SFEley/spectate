require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Spectate::Status do
  before(:each) do
    @this = Spectate::Status.new("http://localhost:47502", '/test/foo/bar_camp', :foo => 'bar', :yoo => 'yar')
  end
  it "behaves like a hash" do
    @this[:foo].should == 'bar'
  end
  
  it "behaves like a struct" do
    @this.yoo.should == 'yar'
  end
  
  it "cannot be altered" do
    lambda{@this[:foo] = 5}.should raise_error
  end
  
  it "knows its source" do
    @this.source.should == '/test/foo/bar'
  end
  
  it "knows its name" do
    @this.name.should == 'bar camp'
  
  it "knows its parent" do
    @this.parent.should == '/test/foo'
  end
  
  it "knows its server" do
    @this.server.should == 'http://localhost:47502'
  end
  
  it "knows its other properties" do
    @this.properties.should have(2).elements
    @this.properties.should include(:foo, :yoo)
  end
end