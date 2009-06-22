require 'rubygems'
require 'sinatra/base'
require 'json'
module Spectate
  class Server < Sinatra::Base
    configure do
      
    end
    
    get '/' do
      {:summary => "Spectate v#{VERSION}"}.to_json
    end
  end
end