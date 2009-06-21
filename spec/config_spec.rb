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
    
    it "can be cleared" do
      Spectate::Config['something'] = 'something else'
      Spectate::Config.clear!
      Spectate::Config.to_hash.size.should == 0
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

      %w[thin webrick mongrel].each do |server|
        describe "#{server}" do
          before(:each) do
            @option = "#{server}"
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
    before(:each) do
      Spectate::Config.clear!
      create_config
      ENV["SPECTATE_DIR"] = nil
    end
    
    it "gets its values from the environment variable if set" do
      ENV["SPECTATE_DIR"] = @tempdir
      Spectate::Config.load_configuration
      Spectate::Config['port'].should == 47502
    end
    
    it "gets its values from the method parameter if given" do
      Spectate::Config.load_configuration(@tempdir)
      Spectate::Config['port'].should == 47502
    end
    
    it "gets its values from Spectate::Config['basedir'] if given" do
      Spectate::Config['basedir'] = @tempdir
      Spectate::Config.load_configuration
      Spectate::Config['port'].should == 47502
    end
    
    it "gets its values from ROOT_DIR as a last resort" do
      Spectate.send(:remove_const, :ROOT_DIR)  # To suppress warnings
      Spectate.const_set(:ROOT_DIR,@tempdir)
      Spectate::Config.load_configuration
      Spectate::Config['port'].should == 47502
      Spectate.send(:remove_const, :ROOT_DIR)  # To suppress warnings
      Spectate.const_set(:ROOT_DIR,nil)
    end
    
    it "complains if no base directory can be found" do
      lambda{Spectate::Config.load_configuration}.should raise_error(RuntimeError, /could not find/i)
    end
    
    it "knows when it hasn't been loaded yet" do
      Spectate::Config.loaded?.should be_false
    end
    
    it "knows when it has been loaded" do
      Spectate::Config.load_configuration(@tempdir)
      Spectate::Config.loaded?.should be_true
    end
    
    it "knows its basedir" do
      Spectate::Config.load_configuration(@tempdir)
      Spectate::Config.basedir.should == @tempdir
    end
      
    after(:each) do
      remove_config
    end
  end
end