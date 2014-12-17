require 'active_record'
require File.join %w(. src data_manipulator)

class Token < ActiveRecord::Base
  belongs_to :key

  scope :outdated, -> { where(fresh: false) }

  before_destroy :destroy_remote

  validates :token, uniqueness: true

  @@data_manipulator = DataManipulator.new

  def ping
    if self.key.connect
      self.key.ping self.token
      $results[:tokens][:pinged] += 1
    else
      Megalogger.warn "Failed to connect to #{ self.platform } using key #{ self.key_data }"
    end
  end

  def verify
    if self.key.verify self.token
      $results[:tokens][:fresh] += 1
    else
      $results[:tokens][:outdated] += 1
      $results[:tokens][:marked] += 1 if self.update_attribute(valid: false)
    end
  end

  def remote_destroy
    token_data = self.to_json.select { |key| [:token, :provider_name, :provider_version, :device_id].include? key }
    @@data_manipulator.delete_token token_data
  end

  def self.update_from_remote
    data = @@data_manipulator.fetch_tokens
    data.each do |datum|
      attributes = Hash[[:token, :provider_name, :provider_version, :device_id].zip(datum)]
      key = Key.find_by_application_version_and_platform attributes[:provider_version], attributes[:provider_name]
      attributes.merge! key_id: (key ? key.id : nil)
      begin
        record = self.create attributes

        $results[:tokens][:saved] += 1 if record.persisted?
      rescue ActiveRecord::RecordNotUnique
        Megalogger.warn "Fetched token already exists in our db"

        search_hash = attributes.select { |attribute_name| [:application_version, :platform].include? attribute_name }
        self.where(search_hash).first.touch
      end
    end
  end
end
