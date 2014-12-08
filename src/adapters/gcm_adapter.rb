module Adapters
  module GCM
    def initialize_connection
      @connection = GCM.new(
      # ...
      )
    end

    def send_notification
      response = @connection.send(
      # ...
      )
    end
  end
end
