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
        FileUtils.cp File.join(File.dirname(__FILE__), '..', 'files', 'config.yml'), @configfile
        FileUtils.cp File.join(File.dirname(__FILE__), '..', '..', 'generators', 'config.ru'), @tempdir
        FileUtils.ln_s File.expand_path(File.join(File.dirname(__FILE__), '..','..')), File.join(@tempdir,'src')
        ENV['SPECTATE_DIR'] = @tempdir
      end
      
      def remove_config
        FileUtils.rm_r @tempdir, :force => true, :secure => true
      end
    end
  end
end