require 'optparse'
require 'spectate'

module Spectate
  SERVER_TYPES = %w[passenger]
  
  PASSENGER_DEFAULTS = {
    'rackup' => false,
    'server' => 'passenger',
    'host'   => 'spectate.local',
  }
  
  RACKUP_DEFAULTS = {
    'rackup' => true,
    'host'   => 'localhost',
    'port'   => 20574
  }
  
  # Drives the 'spectate' command line utility.
  class Command
    
    # The primary event called by the command line
    def self.run
      skip_server = false
      only_setup = false
      unless ARGV.empty?
        options = OptionParser.new
        options.on("-d=DIR", "--directory=DIR", String, "Set base directory for support files (default is ~/.spectate)") do |val| 
          Spectate::Config[:basedir] = val
          puts "Directory set to #{Spectate::Config[:basedir]}"
        end
        options.on("--setup", "=TYPE", SERVER_TYPES, "Create the base directory and initialize config.yml with the given server type (#{SERVER_TYPES.join(', ')})") do |type|
          only_setup = true
          Spectate::Config['server'] = type
          case type
          when 'passenger':
            Spectate::Config.default(PASSENGER_DEFAULTS)
          end
        end
        options.on("--help", "-?", "--usage", "Displays this help screen") {|o| puts options.to_s; skip_server = true}
        unparsed = options.parse(ARGV)
      end
      
      if only_setup
        Spectate::Config.generate_configuration
      else
        Spectate::Config.load_configuration
        self.ensure_server unless skip_server
      end
      true
    rescue OptionParser::ParseError
      puts "Oops... #{$!}"
      puts options
      false
    rescue StandardError
      puts $!
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