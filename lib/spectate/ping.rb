module Spectate
  module Ping
    def ping
      c = Spectate::Client.new
      c.get
    end
  end
end