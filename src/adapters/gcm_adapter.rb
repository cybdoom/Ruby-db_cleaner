module Adapters
  module GCM
    def connect key
      @connection = GCM.new key[:key_data]
    end

    def ping token_data
      message = {
        data: {},
        collapse_key: 'ping'
      }

      @connection.send token_data[:token], message
    end
  end
end
