require 'helpers/config_helpers'

module Spectate
  module Spec
    module ServerHelpers
      include ConfigHelpers
      
      def start_server
        create_config
        `spectate`
      end
      
      def stop_server
        remove_config
      end
    end
  end
end