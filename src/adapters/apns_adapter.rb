module Adapters
  module APNS
    def initialize_connection
      @connection = Grocer.pusher(
      # ...
      )
    end

    def send_notification
      notification = Grocer::Notification.new(
      # ...
      )
      @connection.push notification
    end
  end
end
