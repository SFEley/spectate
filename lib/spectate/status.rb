module Spectate
  class Status
    include Encode
    attr_reader :server, :source
    def initialize(server, source, properties = {})
      @server, @source = server, source
      @status = properties.inject({}) do |status, (key, value)|  # Shamelessly lifted from ActiveSupport
        status[(key.to_sym rescue key) || key] = value
        status
      end
    end
    
    # An array of all the properties contained in this Status object.
    def properties
      @status.keys
    end
    
    # Returns the path of the spectator that owns this source. In practical 
    # terms, this simply truncates to the next-to-last element on the path; so
    # if the source is '/examples/foo/re_bar' the parent would be
    # '/examples/foo'.
    def parent
      @source.slice %r{^/.*(?=/)}
    end
    
    # The English representation of the name of the spectator belonging to this source.
    def name
      decode @source.slice(%r{/[^/]+$}).delete('/')  # Ruby 1.8 doesn't support lookbehind
    end
    
    def [](key)
      @status[key]
    end
      
    def method_missing(method, *args, &block)
      if @status.has_key?(method)
        @status[method]
      else
        super
      end
    end
  end
end