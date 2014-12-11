module Adapters
  module APNS
    def initialize_connection key_data
      @connection = Grocer.pusher(
      # ...
      )
    end

    def verify_token token_data
      # stub
      true
    end
  end
end
