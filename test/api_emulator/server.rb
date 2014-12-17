require 'sinatra'
require 'json'

require './settings'

id = 1
KEYS = []
100.times do |t|
  KEYS << [
    ['APNS', 'GCM'].sample,  # platform
    "v#{t + 1}",             # application_version
    SecureRandom.hex(32)     # key_data
  ]
  id += 1
end

def keys_list
  KEYS.to_json
end

def tokens_list
  response = []
  pages = 10
  (params['page'].to_i < pages ? params['per_page'].to_i : params['per_page'].to_i - 1).times do
    response << [
      SecureRandom.hex(16),                         # token
      ['APNS', 'GCM'].sample,                       # provider_name
      "v#{ 1 + SecureRandom.random_number(100) }",  # provider_version
      SecureRandom.hex(16)                          # device_id
    ]
  end

  response.to_json
end

def delete_token
  true.to_json
end

Settings.data_api.resources.each do |name, url|
  get "/#{ url }" do
    content_type :json
    self.method(name).call
  end
end
