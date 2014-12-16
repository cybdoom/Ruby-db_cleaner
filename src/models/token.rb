require 'active_record'

class Token < ActiveRecord::Base
  belongs_to :key

  scope :invalid, -> { where(valid: false) }

  before_destroy :destroy_remote

  validates :token, uniqueness: true

  def ping
    self.key.ping self.token
  end

  def verify
    if self.key.verify self.token
      $results[:valid] += 1
    else
      $results[:invalid] += 1
      $results[:marked] += 1 if self.update_attribute(valid: false)
    end
  end

  def remote_destroy
    token_data = self.to_json.select { |key| [:token, :provider_name, :provider_version, :device_id].include? key }
    Key.data_manipulator.delete_token token_data
  end
end
