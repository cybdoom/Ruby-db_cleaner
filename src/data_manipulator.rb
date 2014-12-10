require 'rest_client'

class DataManipulator
  TOKENS_PER_PAGE = 100

  def initialize
    url_prefix = "http://#{Settings.data_api.server}:#{Settings.data_api.port}/"
    @resources = {}
    @page = 0
    Settings.data_api.resources.each { |k, v| @resources[k] = RestClient::Resource.new "#{ url_prefix }#{ v }" }
  end

  def fetch_keys
    parse_keys @resources[:keys_list].get
  end

  def fetch_some_tokens
    @page += 1
    response_html = @resources[:tokens_list].get page: @page, per_page: TOKENS_PER_PAGE
    parse_tokens response_html
    # stub
    # [
    #   {
    #     token: 'someuniqtoken',
    #     provider_name: 'APNS',
    #     provider_version: '0.8'
    #     device_id: 'someuniqid'
    #   },
    #   {
    #     token: 'nextuniqtoken',
    #     provider_name: 'APNS',
    #     provider_version: '0.9'
    #     device_id: 'nextuniqid'
    #   }
    # ]
  end

  def delete_token token_data
    @resources[:delete_token].delete token_data
  end

  private

  def parse_keys html
    html
  end

  def parse_tokens html
    html
  end
end
