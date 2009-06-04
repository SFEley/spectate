require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'tmpdir'
require 'fileutils'

describe "Configuration" do
  describe "variables" do
    it "can be set" do
      Spectate::Config[:foo] = 'bar'
      Spectate::Config[:foo].should == 'bar'
    end
    
    it "can be displayed as a hash" do
      Spectate::Config[:bar] = 'foo'
      hash = Spectate::Config.to_hash
      hash[:bar].should == 'foo'
    end
  end
  
  describe "file handling" do
    # We don't want to mess up anyone's actual configuration
    before(:all) do
      @tempparent = Dir.mktmpdir
      @tempdir = File.join(@tempparent, '.spectate')
      @configfile = File.join(@tempdir, 'config.yml')
    end
  
    describe "without a .spectate directory" do
      before(:each) do
        FileUtils.rm_r @tempdir, :force => true, :secure => true
      end
    
      it "tells the user it's being created" do
        `spectate -d #{@tempdir}`.should =~ /Creating \.spectate directory/
      end
      
      it "creates the directory" do
        `spectate -d #{@tempdir}`
        File.directory?(@tempdir).should be_true
      end
    end
    
    describe "with a .spectate directory" do
      before(:all) do
        Dir.mkdir @tempdir
      end
      
      describe "without a config.yml file" do
        before(:each) do
          File.delete(@configfile) if File.exists?(@configfile)
        end
        
        it "tells the user a config.yml file is being made" do
          `spectate -d #{@tempdir}`.should =~ /Creating config.yml file/
        end
        
        it "creates the file" do
          `spectate -d #{@tempdir}`
          File.exists?(@configfile).should be_true
        end
        
          
      end
    end
  
    
    after(:all) do
      FileUtils.rm_r @tempparent, :force => true, :secure => true
    end
  end
end