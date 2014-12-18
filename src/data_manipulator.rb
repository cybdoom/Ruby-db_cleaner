require 'rest_client'

require_relative 'parser'

# Manipulates with remote DB using rest api
class DataManipulator
  # for parsing responses, defines [:parse_keys, :parse_tokens] methods
  include Parser::JSON

  TOKENS_PER_PAGE = 100

  def initialize
    # initialize resource
    @resources = {}
    #
    url_prefix = "#{ Settings.data_api.protocol }://#{Settings.data_api.server}:#{Settings.data_api.port}/"
    Settings.data_api.resources.each { |k, v| @resources[k] = RestClient::Resource.new "#{ url_prefix }#{ v }" }
    # # # # # # # # # # #

    # for fetching tokens page by page
    @page = 0
  end

  def fetch_keys
    # GET /<key_list_url>
    parse_keys @resources['keys_list'].get
  rescue URI::InvalidURIError, Errno::ECONNREFUSED
    Megalogger.error 'Failed to fetch keys: unable to talk with the remote server'
    abort
  end

  # fetch some portion of tokens data from the remote server
  def fetch_some_tokens
    # GET /<tokens_list_url>?page=@page&per_page=@per_page
    @page += 1
    response = @resources['tokens_list'].get params: { page: @page, per_page: TOKENS_PER_PAGE }

    tokens_portion = parse_tokens response
    tokens_portion.count == TOKENS_PER_PAGE ? tokens_portion : nil
  rescue URI::InvalidURIError, Errno::ECONNREFUSED
    Megalogger.warn 'Failed to fetch tokens: unable to talk with the remote server'
  end

  def delete_token token_data
    # DELETE /<delete_token_url>?token_data
    @resources['delete_token'].delete token_data
  rescue URI::InvalidURIError, Errno::ECONNREFUSED
    Megalogger.warn 'Failed to delete token: unable to talk with the remote server'
  end

end
