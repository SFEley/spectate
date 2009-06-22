require 'spectate'
require 'restclient'
require 'json'

module Spectate
  class Client
    attr_accessor :protocol, :host, :port, :accept
    
    def initialize(options = {})
      Spectate::Config.load_configuration unless Spectate::Config.loaded?
      @protocol = options[:protocol] || Spectate::Config['protocol'] || 'http'
      @host = options[:host] || Spectate::Config['host'] || 'localhost'
      @port = options[:port] || Spectate::Config['port'] || 0
      @accept = options[:accept] || Spectate::Config['accept'] || 'application/json'
      
      @driver = RestClient::Resource.new(root, :accept => accept)
    end

    def root
      protocol.tr(':/','') + 
      '://' +
      host + 
      ((port.to_i > 0) ? ":#{port}" : '')
    end
    
    def get
      response = @driver.get
      s = Spectate::Status.new(root,'/',JSON.parse(response)) if accept == 'application/json'
    rescue RestClient::ResourceNotFound
      nil
    rescue Errno::ECONNREFUSED
      nil
    end
  end
end