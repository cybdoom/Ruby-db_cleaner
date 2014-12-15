require 'active_record'

class Key < ActiveRecord::Base
  validate :key_data, uniqueness: true

  def connect
    require_relative File.join '..', 'adapters', "#{self.platform.downcase}_adapter"
    include eval("Adapters::#{ self.platform }")
    self.connect self.key_data
  end

  def self.data_manipulator
    @@data_manipulator ||= DataManipulator.new
  end
end
