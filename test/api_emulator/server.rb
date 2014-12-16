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
  content_type :json

  KEYS.to_json
end

def tokens_list
  content_type :json

  response = []
  tokens_count = 100000
  params['per_page'].times { response << [
    SecureRandom.hex(16),                         # token
    "v#{ 1 + SecureRandom.random_number(100) }",  # provider_version
    ['APNS', 'GCM'].sample,                       # provider_name
    SecureRandom.hex(16)                          # device_id
  ] }

  response.to_json
end

def delete_token
  content_type :json

  true.to_json
end

Settings.data_api.resources.each do |name, url|
  get "/#{ url }" do
    self.method(name).call
  end
end
