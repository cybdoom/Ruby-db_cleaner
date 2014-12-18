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

    def update_status token_data
      return ['good', 'suspicious', 'bad'].sample if ENVIRONMENT == 'test'

      message = {
        data: {},
        collapse_key: 'verify'
      }

      response = @connection.send token_data['token'], message

      case response[:results][:error]
      when 'NotRegistered'
        'bad'
      when 'Unavailable'
        'suspicious'
      else
        Megalogger.warn "Unhandled error was recieved from GCM service:\n#{ response[:results][:error] }\nThe token was marked as 'good'"
        'good'
      end
    end
  end
end
