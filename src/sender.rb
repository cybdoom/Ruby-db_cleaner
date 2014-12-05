class Sender
  def initialize options
    @adapter = eval("#{ options[:service] }_Adapter").new
  end

  def send_notification
    @adapter.send_notification
  end
end
