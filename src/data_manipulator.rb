require 'rest_client'

require_relative File.join %w(. parser)

# Manipulates with remote DB using rest api
class DataManipulator
  # for parsing responses, defines [:parse_keys, :parsetokens] methods
  include Parser::HTML

  TOKENS_PER_PAGE = 100

  def initialize
    # for fetching tokens page by page
    @page = 0

    # initialize resource
    @resources = {}
    #
    url_prefix = "http://#{Settings.data_api.server}:#{Settings.data_api.port}/"
    Settings.data_api.resources.each { |k, v| @resources[k] = RestClient::Resource.new "#{ url_prefix }#{ v }" }
    # # # # # # # # # # #
  end

  def fetch_keys
    # GET /<key_list_url>
    parse_keys @resources['keys_list'].get
  rescue URI::InvalidURIError
    Logger.error 'Failed to fetch keys: unable to talk with the remote server'
    abort
  end

  def fetch_some_tokens
    @page += 1

    # GET /<tokens_list_url>?page=@page&per_page=@per_page
    response_html = @resources['tokens_list'].get page: @page, per_page: TOKENS_PER_PAGE
    parse_tokens response_html
    # STUB
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
  rescue URI::InvalidURIError
    Logger.warn 'Failed to fetch tokens: unable to talk with the remote server'
  end

  def delete_token token_data
    # DELETE /<delete_token_url>?token_data
    @resources['delete_token'].delete token_data
  rescue URI::InvalidURIError
    Logger.warn 'Failed to delete token: unable to talk with the remote server'
  end

end
