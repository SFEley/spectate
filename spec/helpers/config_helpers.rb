require 'tmpdir'
require 'fileutils'

module Spectate
  module Spec
    module ConfigHelpers
      def set_tempdir
        @tempparent = Dir.mktmpdir
        @tempdir = File.join(@tempparent, '.spectate')
        @configfile = File.join(@tempdir, 'config.yml')
      end
      
      def create_config
        @tempdir = Dir.mktmpdir
        @configfile = File.join(@tempdir, 'config.yml')
        FileUtils.cp File.join(SPECDIR, 'files', 'config.yml'), @configfile
        ENV['SPECTATE_DIR'] = @tempdir
      end
      
      def remove_config
        FileUtils.rm_r @tempdir, :force => true, :secure => true
      end
    end
  end
end