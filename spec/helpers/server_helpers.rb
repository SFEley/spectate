require 'helpers/config_helpers'

module Spectate
  module Spec
    module ServerHelpers
      include ConfigHelpers
      
      def start_server
        create_config
        call = `spectate`
        puts call unless call =~ /Starting Spectate.\s*$/m
      end
      
      def stop_server
        `spectate --stop`
        remove_config
      end
    end
  end
end