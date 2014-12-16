require 'sinatra'
require 'sinatra/json'

require 'settings'

Settings.data_api.resources.each { |name, url|
  get url lambda(&self.method(name))
end

id = 1
keys = {}
100.times do |t|
  keys << [
    id                       # id
    ['APNS', 'GCM'].sample,  # platform
    "v#{t + 1}",             # application_version
    SecureRandom.hex 32      # key_data
  ]
  id += 1
end

def keys_list
  json keys
end

def tokens_list
  response = []
  tokens_count = 100000
  params['per_page'].times { response << [
    SecureRandom.hex 16,                          # token
    "v#{ 1 + SecureRandom.random_number(100) }",  # provider_version
    ['APNS', 'GCM'].sample,                       # provider_name
    SecureRandom.hex 16                           # device_id
  ] }
  json response
end

def delete_token
  json true
end
