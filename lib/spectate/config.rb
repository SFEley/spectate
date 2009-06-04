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
      unless File.directory?(self[:basedir])
        puts "Creating #{File.basename(self[:basedir])} directory..."
        FileUtils.makedirs self[:basedir]
      end
    end
        
  end
  
end