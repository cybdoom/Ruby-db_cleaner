require 'active_record'
require File.join %w(. src data_manipulator)

class Token < ActiveRecord::Base
  belongs_to :key

  scope :since, ->(time) { where("updated_at > ?", time) }

  before_destroy :destroy_remote

  validates :token, uniqueness: true

  @@data_manipulator = DataManipulator.new

  def self.update_from_remote
    loop do
      data = @@data_manipulator.fetch_some_tokens
      break unless data

      data.each do |datum|
        attributes = Hash[[:token, :provider_name, :provider_version, :device_id].zip(datum)]
        key = Key.find_by_application_version_and_platform attributes[:provider_version], attributes[:provider_name]
        attributes.merge! key_id: (key ? key.id : nil)
        begin
          record = self.create attributes
        rescue ActiveRecord::RecordNotUnique
          Megalogger.warn "Fetched token already exists in our db"

          search_hash = attributes.select { |attribute_name| [:application_version, :platform].include? attribute_name }
          self.where(search_hash).first.touch
        end
      end

      Megalogger.info 'Fetched tokens portion'
    end
  end

end
