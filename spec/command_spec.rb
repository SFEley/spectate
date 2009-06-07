require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'helpers/config_helpers'

describe "Command 'spectate'" do
  include Spectate::Spec::ConfigHelpers
  
  before(:all) do
    create_config
  end
  
  it "gets its base directory from the SPECTATE_DIR environment variable if specified" do
    unmade_dir = File.expand_path("~/blahhhhh")
    ENV['SPECTATE_DIR'] = unmade_dir
    `spectate`.should =~ /Directory #{Regexp.escape(unmade_dir)} not found!/
    ENV['SPECTATE_DIR'] = @tempdir
  end
  
  it "executes" do
    system('spectate').should_not be_nil
  end
  
  # We have several options for displaying help
  %w{-h -? --help --usage}.each do |option|
    it "displays its usage when called with #{option}" do
      `spectate #{option}`.should =~ /Usage:/
    end
    
    it "does not attempt to start the server if called with #{option}" do
      `spectate #{option}`.should_not =~ /Starting Spectate/
    end 
    
  end
  
  it "displays its usage when given parameters it doesn't understand" do
    `spectate --blah1234`.should =~ /invalid option: --blah1234.*Usage:/m
  end
  
  it "attempts to start Spectate if not already running" do
    `spectate -d #{@tempdir}`.should =~ /Starting Spectate/
  end
  
  %w{-d --directory}.each do |option|
    it "requires a directory parameter" do
      `spectate #{option}`.should =~ /missing argument: #{option}.*Usage:/m
    end
    
    it "sets a different base directory when called with #{option} dirname" do
      tmpdir = Dir.tmpdir
      `spectate #{option} #{tmpdir}`.should =~ /Directory set to #{Regexp.escape(tmpdir)}/
      # Ensure cleanup
      FileUtils.rm_r tmpdir, :force => true, :secure => true
    end
  end
  
  after(:all) do
    remove_config
  end
end
