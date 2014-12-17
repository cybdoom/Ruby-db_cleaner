module Adapters
  class GCM
    def connect key
      return true if ENVIRONMENT == 'test'

      @connection = GCM.new key['key_data']
      true
    rescue
      Megalogger.warn "Connection to GCM failed, used key: #{ key['key_data'] }"
      false
    end

    def ping token_data
      return true if ENVIRONMENT == 'test'

      message = {
        data: {},
        collapse_key: 'ping'
      }

      @connection.send token_data['token'], message
      true
    rescue
      Megalogger.warn "Failed to ping token: #{ token }"
      false
    end

    def verify token_data
      return true if ENVIRONMENT == 'test'

      message = {
        data: {},
        collapse_key: 'verify'
      }

      response = @connection.send token_data['token'], message
      response[:results][:error] != 'NotRegistered'
    end
  end
end
