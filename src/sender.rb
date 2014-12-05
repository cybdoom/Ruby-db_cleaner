class Sender
  def initialize options
    @adapter = eval("#{ options[:service] }_Adapter").new
  end

  def send_notification
    @adapter.send_notification
    invoke_callback_listener if @adapter.class.name.split('_').first == 'APNS'
  end
end
