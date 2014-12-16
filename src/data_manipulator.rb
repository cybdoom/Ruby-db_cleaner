require 'rest_client'

require_relative 'parser'

# Manipulates with remote DB using rest api
class DataManipulator
  # for parsing responses, defines [:parse_keys, :parse_tokens] methods
  include Parser::JSON

  TOKENS_PER_PAGE = 100

  def initialize
    # for fetching tokens page by page
    @page = 0

    # initialize resource
    @resources = {}
    #
    url_prefix = "#{ Settings.data_api.protocol }://#{Settings.data_api.server}:#{Settings.data_api.port}/"
    Settings.data_api.resources.each { |k, v| @resources[k] = RestClient::Resource.new "#{ url_prefix }#{ v }" }
    # # # # # # # # # # #
  end

  def fetch_keys
    # GET /<key_list_url>
    keys = parse_keys @resources['keys_list'].get
    $results[:keys][:fetched] = keys.count
    keys
  rescue URI::InvalidURIError
    Megalogger.error 'Failed to fetch keys: unable to talk with the remote server'
    abort
  end

  # fetch some portion of tokens data from the remote server
  def fetch_some_tokens
    @page += 1

    # GET /<tokens_list_url>?page=@page&per_page=@per_page
    response = @resources['tokens_list'].get page: @page, per_page: TOKENS_PER_PAGE

    tokens = parse_tokens(response)
    $results[:tokens][:fetched] = tokens.count
    tokens
  rescue URI::InvalidURIError
    Megalogger.warn 'Failed to fetch tokens: unable to talk with the remote server'
  end

  def delete_token token_data
    # DELETE /<delete_token_url>?token_data
    @resources['delete_token'].delete token_data
  rescue URI::InvalidURIError
    Megalogger.warn 'Failed to delete token: unable to talk with the remote server'
  end

end
