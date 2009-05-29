require 'optparse'

module Spectate
  
  # Drives the 'spectate' command line utility.
  class Command
    
    # The primary event called by the command line
    def self.run
      options = OptionParser.new
      options.on("--help", "-?", "--usage", "Displays this help screen") {|o| puts options.to_s}
      unparsed = options.parse(ARGV)
      true
    rescue OptionParser::ParseError
      puts "Oops... #{$!}"
      puts options
    end
  end
end