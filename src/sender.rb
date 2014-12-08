class Sender
  def initialize options
    self.class.include eval("Adapters::#{ options[:service].upcase }")
    self.initialize_connection
  end
end
