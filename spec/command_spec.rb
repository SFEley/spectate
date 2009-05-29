require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Command 'spectate'" do
  it "executes" do
    system('spectate').should be_true
  end
  
  # We have several options for displaying help
  %w{-h -? --help --usage}.each do |option|
    it "displays its usage when called with #{option}" do
      `spectate #{option}`.should =~ /Usage:/
    end
  end
  
  it "displays its usage when given parameters it doesn't understand" do
    `spectate --blah1234`.should =~ /invalid option: --blah1234.*Usage:/m
  end
end
