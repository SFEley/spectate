require 'rubygems'
require 'sinatra/base'

module Spectate
  class Server < Sinatra::Base
    configure do
      
    end
    
    get '/' do
      "Spectate v#{VERSION}"
    end
  end
end