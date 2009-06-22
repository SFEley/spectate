require 'optparse'
require 'spectate'

module Spectate
  SERVER_TYPES = %w[passenger thin mongrel webrick]
  
  PASSENGER_DEFAULTS = {
    'rackup' => false,
    'server' => 'passenger',
    'host'   => 'spectate.local'
  }
  
  RACKUP_DEFAULTS = {
    'rackup' => true,
    'host'   => 'localhost',
    'port'   => 20574
  }
  
  # Drives the 'spectate' command line utility.
  class Command
    extend Spectate::Ping
    
    # The primary event called by the command line
    def self.run
      skip_server = false
      only_setup = false
      stop_server = false
      unless ARGV.empty?
        options = OptionParser.new
        options.on("-d", "--directory", "=DIR", String, "Set base directory for support files (default is ~/.spectate)") do |val| 
          Spectate::Config['basedir'] = val
          puts "Directory set to #{Spectate::Config['basedir']}"
        end
        options.on("--setup", "=TYPE", SERVER_TYPES, "Create the base directory and initialize config.yml with the given server type (#{SERVER_TYPES.join(', ')})") do |type|
          only_setup = true
          Spectate::Config['server'] = type
          case type
          when 'passenger':
            Spectate::Config.default(PASSENGER_DEFAULTS)
          else
            Spectate::Config.default(RACKUP_DEFAULTS)
          end
        end
        options.on("--host", "-h", "=NAME", String, "Set hostname or IP address for server access") do |host|
          Spectate::Config['host'] = host
        end
        options.on("--port", "-p", "=PORT", Integer, "Set port number for server access") do |port|
          Spectate::Config['port'] = port
        end
        options.on("--help", "-?", "--usage", "Displays this help screen") {|o| puts options.to_s; skip_server = true}
        options.on("--stop", "Stops the Spectate server if running") {stop_server = true}
        unparsed = options.parse(ARGV)
      end
      
      if only_setup
        Spectate::Config.generate_configuration
      else
        Spectate::Config.load_configuration
        if stop_server
          self.kill_server
        else
          self.ensure_server unless skip_server
        end
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
      if ping
        puts "Spectate is already running!"
      else
        puts "Starting Spectate on #{Spectate::Config['host']}:#{Spectate::Config['port']}..."
        Dir.chdir Spectate::Config.basedir do |dir|
          system "rackup -D -o #{Spectate::Config['host']} -p #{Spectate::Config['port']} -P spectate.pid config.ru"
        end
      end
    end
    
    def self.kill_server()
      pidfile = File.join(Spectate::Config.basedir, 'spectate.pid')
      pid = File.read(pidfile).to_i if File.exists?(pidfile)
      if pid and `ps x #{pid}` =~ /rackup.*-p #{Spectate::Config['port']}/
        Process.kill("KILL",pid) and puts "Spectate stopped."
        File.delete(pidfile)
      else
        puts "Spectate wasn't running! (Or you're using Passenger, or your PID file is incorrect,\n  or it's on a different server.  In any case, you're on your own.)"
      end
    end
  end
end