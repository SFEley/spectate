require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Command 'spectate'" do
  it "should execute" do
    system("spectate").should be_true
  end
end
