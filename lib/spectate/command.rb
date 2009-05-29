module Spectate
  
  # Drives the 'spectate' command line utility.
  class Command
    # The primary event called by the command line
    def self.run
      puts __FILE__
      true
    end
  end
end