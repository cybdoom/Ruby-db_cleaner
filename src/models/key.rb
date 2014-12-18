require 'active_record'
require File.join %w(. src data_manipulator)

class Key < ActiveRecord::Base
  has_many :tokens

  scope :since, ->(time) { where("updated_at > ?", time) }

  validate :key_data, uniqueness: true

  @@data_manipulator = DataManipulator.new

  def self.update_from_remote
    data = @@data_manipulator.fetch_keys
    data.each do |datum|
      attributes = Hash[[:platform, :application_version, :key_data].zip(datum)]
      begin
        record = self.create attributes
      rescue ActiveRecord::RecordNotUnique
        Megalogger.warn "Fetched key already exists in our db"

        search_hash = attributes.select { |attribute_name| [:application_version, :platform].include? attribute_name }
        self.where(search_hash).first.touch
      end
    end
  end
end
