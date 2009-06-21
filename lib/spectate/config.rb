require 'fileutils'
require 'yaml'

module Spectate
  module Config
    @config = Hash.new
    @loaded = false
    
    def self.to_hash
      @config
    end
      
    def self.[](key)
      @config[key]
    end
    
    def self.[]=(key, val)
      @config[key] = val
    end
    
    def self.delete(key)
      @config.delete(key)
    end
    
    def self.clear!
      @config = Hash.new
      @loaded = false
    end
    
    def self.default(hash)
      @config = hash.merge(@config)
    end
    
    def self.basedir
      @basedir
    end
    
    def self.loaded?
      @loaded
    end
    
    # Loads persistent values from the config.yml file in the base directory.
    # Assumes that the basedir configuration variable has already been set before calling.
    def self.load_configuration(confdir = nil)
      @basedir = confdir || self['basedir'] || ENV['SPECTATE_DIR'] || ROOT_DIR
      raise "Could not find a base directory!\nRun spectate --setup to initialize things or tell us your base directory\nwith the -d option." unless basedir
      raise "Directory #{basedir} not found!\nRun spectate --setup to initialize things." unless File.directory?(basedir)
      conffile = File.join(basedir, "config.yml")
      raise "File #{conffile} not found!\nRun spectate --setup to initialize things." unless File.exists?(conffile)
      @loaded = @config.merge!(YAML.load_file(conffile))
    end

    # Confirms that the config.yml file doesn't already exist, then creates one from passed parameters
    def self.generate_configuration
      configfile = File.join(self['basedir'], "config.yml")
      raise "You already have a config.yml file!  We don't want to mess with a good thing.\n" +
            "If you really want to start over, delete #{configfile} and run spectate --setup again." if File.exists?(configfile)
      unless File.directory?(self['basedir'])
        puts "Creating directory #{self['basedir']}"
        FileUtils.makedirs self['basedir']
      end
      puts "Creating config.yml file"
      File.open(configfile, 'w') {|config| YAML.dump(self.to_hash, config)}
      puts "Creating rackup file"
      FileUtils.copy File.join(File.dirname(__FILE__), '..', '..', 'generators', 'config.ru'), self['basedir']
    end
      
        
  end
  
end