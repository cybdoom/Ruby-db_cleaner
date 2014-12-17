module Adapters
  module GCM
    def init_connection key_data
      return true if ENVIRONMENT == 'test'

      @connection = GCM.new key[:key_data]
      true
    rescue
      Megalogger.warn "Connection to GCM failed, used key: #{ key_data }"
      false
    end

    def ping token
      message = {
        data: {},
        collapse_key: 'ping'
      }

      @connection.send token, message
      true
    rescue
      Megalogger.warn "Failed to ping token: #{ token }"
      false
    end

    def verify token
      message = {
        data: {},
        collapse_key: 'verify'
      }

      response = @connection.send token, message
      response[:$results][:error] != 'NotRegistered'
    end
  end
end
