class Key < ActiveRecord::Base
  def self.fetch

  end

  def connect
    if @connection.nil?
      require_relative File.join '..', 'adapters', "#{self.platform.downcase}_adapter"
      include eval("Adapters::#{ self.platform }")
    end
  end

  @@data_manipulator = DataManipulator.new
end
