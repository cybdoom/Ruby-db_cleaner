module Adapters
  module APNS
    def init_connection key_data
      return true if ENVIRONMENT == 'test'

      @connection = Grocer.pusher(
        certificate:  StringIO.new(key_data),
        gateway:      Settings.service.apns.gateway,
        port:         Settings.service.apns.port,
        retries:      Settings.service.apns.retries
      )

      @feedback = Grocer.feedback(
        certificate:  StringIO.new(key_data),
        gateway:      Settings.service.feedback.gateway,
        port:         Settings.service.feedback.port,
        retries:      Settings.service.feedback.retries
      )
      true
    rescue
      Megalogger.warn "Connection to APNS failed, used key: #{ key_data }"
      false
    end

    def ping token
      notification = Grocer::NewsstandNotification.new(device_token: token)

      @@connections[self.key].push notification
      true
    rescue
      Megalogger.warn "Failed to ping token: #{ token }"
      false
    end

    def verify token
      @feedback.each do |info|
        return false if info.device_token == token
      end

      true
    end
  end
end
