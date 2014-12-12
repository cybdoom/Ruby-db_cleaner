module Adapters
  module APNS
    def open_connect key
      @connection = Grocer.pusher(
        certificate:  StringIO.new(key.data)
        gateway:      Settings.service.apns.gateway
        port:         Settings.service.apns.port,
        retries:      3
      )
    end

    def ping
      notification = Grocer::NewsstandNotification.new(device_token: self.token)

      @@connections[self.key].push notification
    end

    def verify
    end
  end
end
