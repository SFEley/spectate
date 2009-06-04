require 'optparse'
require 'spectate'

module Spectate
  DEFAULT_PORT = "20574"
  
  # Drives the 'spectate' command line utility.
  class Command
    
    # The primary event called by the command line
    def self.run
      skip_server = false
      unless ARGV.empty?
        options = OptionParser.new
        options.on("-d=DIR", "--directory=DIR", String, "Set base directory for support files (default is ~/.spectate)") do |val| 
          Spectate::Config[:basedir] = val
          puts "Directory set to #{Spectate::Config[:basedir]}"
        end
        options.on("--help", "-?", "--usage", "Displays this help screen") {|o| puts options.to_s; skip_server = true}
        unparsed = options.parse(ARGV)
      end
      
      Spectate::Config.load_configuration
      self.ensure_server unless skip_server
      true
    rescue OptionParser::ParseError
      puts "Oops... #{$!}"
      puts options
      false
    end
    
  private
    def self.ensure_server
      # TODO: Check for existing server running
      puts "Starting Spectate..."
    end
  end
end