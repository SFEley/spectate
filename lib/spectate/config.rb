require 'fileutils'
require 'yaml'

module Spectate
  module Config
    @config = Hash.new
    
    def self.to_hash
      @config
    end
      
    def self.[](key)
      @config[key]
    end
    
    def self.[]=(key, val)
      @config[key] = val
    end
    
    # Loads persistent values from the config.yml file in the base directory.
    # Assumes that the :basedir configuration variable has already been set before calling.
    def self.load_configuration
      raise "Directory #{self[:basedir]} not found!\nRun spectate --setup to initialize things." unless File.directory?(self[:basedir])
      configfile = File.join(self[:basedir], "config.yml")
      raise "File #{self[:basedir]}/config.yml not found!\nRun spectate --setup to initialize things." unless File.exists?(configfile)
    end

    # Confirms that the config.yml file doesn't already exist, then creates one from passed parameters
    def self.generate_configuration
      configfile = File.join(self[:basedir], "config.yml")
      raise "You already have a config.yml file!  We don't want to mess with a good thing.\n" +
            "If you really want to start over, delete #{configfile} and run spectate --setup again." if File.exists?(configfile)
      unless File.directory?(self[:basedir])
        puts "Creating directory #{self[:basedir]}"
        FileUtils.makedirs self[:basedir]
      end
      puts "Creating config.yml file"
      File.open(configfile, 'w') {|config| YAML.dump(self.to_hash, config)}
    end
      
        
  end
  
end