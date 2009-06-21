require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

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
    `spectate --help`.should =~ /Spectate/i
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
  
  
  %w{-d --directory}.each do |option|
    it "requires a directory parameter" do
      `spectate #{option}`.should =~ /missing argument: #{option}.*Usage:/m
    end
    
    it "sets a different base directory when called with #{option} dirname" do
      tmpdir = Dir.mktmpdir
      `spectate #{option} #{tmpdir}`.should =~ /Directory set to #{Regexp.escape(tmpdir)}/
      # Ensure cleanup
      FileUtils.rm_r tmpdir, :force => true, :secure => true
    end
  end

  describe "starting" do
    it "attempts to start Spectate if not already running" do
      `spectate`.should =~ /Starting Spectate/
    end
    it "complains if Spectate is already running" do
      `spectate`
      `spectate`.should =~ /already running/
    end
    
    it "creates a PID file in the base directory" do
      `spectate`
      File.exists?(File.join(@tempdir,'spectate.pid')).should be_true
    end
    after(:each) do
      `spectate --stop`
    end
  end
  
  describe "--stop" do
    before(:each) do
      `spectate`
    end
    it "stops the server" do
      `spectate --stop`.should =~ /stopped./
    end
    it "complains if the server wasn't running" do
      `spectate --stop`
      `spectate --stop`.should =~ /wasn't running!/
    end
  end
  
  
  after(:all) do
    remove_config
  end
end
