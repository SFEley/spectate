require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Configuration" do
  describe "version" do
    it "is a proper major.minor.build number" do
      Spectate::VERSION.should =~ /\d+\.\d+\.\d+/
    end
  end
  
  describe "variables" do
    it "can be set" do
      Spectate::Config['foo'] = 'bar'
      Spectate::Config['foo'].should == 'bar'
      Spectate::Config.delete('foo')
    end
    
    it "can be displayed as a hash" do
      Spectate::Config['bar'] = 'foo'
      hash = Spectate::Config.to_hash
      hash['bar'].should == 'foo'
      Spectate::Config.delete('bar')
    end
    
    it "can be deleted" do
      Spectate::Config['foo'] = 'bar'
      Spectate::Config.delete('foo')
      Spectate::Config.to_hash.should_not have_key('foo')
    end
  end
  
  describe "defaults" do
    before(:each) do
      @defhash = {'aloha' => 'hello'}
    end
    
    it "will merge in if they don't exist" do
      Spectate::Config.default(@defhash)
      Spectate::Config['aloha'].should == 'hello'
    end
    
    it "will not merge in if they do exist" do
      Spectate::Config['aloha'] = "goodbye"
      Spectate::Config.default(@defhash)
      Spectate::Config['aloha'].should == 'goodbye'
    end
    
    after(:each) do
      Spectate::Config.delete('aloha')
    end
  end
  
  describe "file setup" do
    include Spectate::Spec::ConfigHelpers
    
    # We don't want to mess up anyone's actual configuration
    before(:all) do
      set_tempdir # Sets @tempparent, @tempdir, @configfile
    end

    describe "without a .spectate directory" do
      before(:each) do
        FileUtils.rm_r @tempdir, :force => true, :secure => true
      end
      
      it "tells the user to run spectate --setup" do
        `spectate -d #{@tempdir}`.should =~ /Directory #{Regexp.escape(@tempdir)} not found!\nRun spectate --setup to initialize things\./m
      end
    end

    describe "without a config.yml file" do
      before(:each) do
        FileUtils.mkdir @tempdir
        File.delete(@configfile) if File.exists?(@configfile)
      end
      
      it "tells the user to run spectate --setup" do
        `spectate -d #{@tempdir}`.should =~ /File #{Regexp.escape(@tempdir)}\/config\.yml not found!\nRun spectate --setup to initialize things\./m
      end
    end
    
    
    shared_examples_for "a valid setup option" do
      it "complains if config.yml already exists" do
        FileUtils.mkdir @tempdir
        FileUtils.touch @configfile
        `spectate -d #{@tempdir} --setup #{@option}`.should =~ /You already have a config\.yml file!  We don't want to mess with a good thing\.\nIf you really want to start over, delete #{Regexp.escape(@tempdir)}\/config\.yml and run spectate --setup again\./m
        
      end
      
      it "tells the user a config.yml file is being made" do
        `spectate -d #{@tempdir}  --setup #{@option}`.should =~ /Creating config.yml file/
      end

      it "creates the file" do
        `spectate -d #{@tempdir}  --setup #{@option}`
        File.exists?(@configfile).should be_true
      end
      
      it "writes the server value to the file" do
        `spectate -d #{@tempdir} --setup #{@option}`
        File.read(@configfile).should =~ /server: #{@option}/
      end
      
      it "writes the host if given" do
        `spectate -d #{@tempdir} -h foo.bar.local --setup #{@option}`
        File.read(@configfile).should =~ /host: foo\.bar\.local/
      end
      
      it "writes the port if given" do
        `spectate -d #{@tempdir} -p 55555 --setup #{@option}`
        File.read(@configfile).should =~ /port: 55555/
      end
      
      it "creates a rackup file" do
        `spectate -d #{@tempdir} --setup #{@option}`
        File.read(File.join(@tempdir,'config.ru')).should =~ /run Spectate::Server/
      end
    end
    
    describe "with spectate --setup" do
      
      describe "(no parameters)" do
        it "tells the user to specify a parameter" do
          `spectate -d #{@tempdir} --setup`.should =~ /missing argument/
        end
      end
      
      describe "passenger" do
        before(:each) do
          @option = "passenger"
        end
        it_should_behave_like "a valid setup option"
        
        it "sets rackup to false" do
          `spectate -d #{@tempdir} --setup #{@option}`
          File.read(@configfile).should =~ /rackup: false/
        end
        
        it "doesn't set a port" do
          `spectate -d #{@tempdir} --setup #{@option}`
          File.read(@configfile).should_not =~ /port/
        end
        
        it "defaults the host to spectate.local" do
          `spectate -d #{@tempdir} --setup #{@option}`
          File.read(@configfile).should =~ /host: spectate\.local/
        end
      end

    
      describe "builtin" do
        before(:each) do
          @option = "builtin"
        end

        it_should_behave_like "a valid setup option"

        it "sets rackup to true" do
          `spectate -d #{@tempdir} --setup #{@option}`
          File.read(@configfile).should =~ /rackup: true/
        end

        it "sets the port to the default of 20574" do
          `spectate -d #{@tempdir} --setup #{@option}`
          File.read(@configfile).should =~ /port: 20574/
        end

        it "defaults the host to localhost" do
          `spectate -d #{@tempdir} --setup #{@option}`
          File.read(@configfile).should =~ /host: localhost/
        end
      end
      
      after(:each) do
        FileUtils.rm_r @tempdir, :force => true, :secure => true
      end
    end

    
    after(:all) do
      FileUtils.rm_r @tempparent, :force => true, :secure => true
    end
  end
  
  describe "loading" do
    include Spectate::Spec::ConfigHelpers
    before(:all) do
      create_config
      Spectate::Config[:basedir] = @tempdir
    end
    
    it "sets Spectate::Config with values from the config file" do
      Spectate::Config.load_configuration
      Spectate::Config['port'].should == 47502
    end
      
    after(:all) do
      remove_config
    end
  end
end