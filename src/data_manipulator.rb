require 'rest_client'
require 'json'

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
    url_prefix = "#{ Settings.data_api.protocol }://#{Settings.data_api.server}:#{Settings.data_api.port}/"
    Settings.data_api.resources.each { |k, v| @resources[k] = RestClient::Resource.new "#{ url_prefix }#{ v }" }
    # # # # # # # # # # #

    # initialize connection with Redis
    @mysql_client = Redis.new driver: :hiredis
  end

  def fetch_keys
    # GET /<key_list_url>
    # save all info in redis under the key 'keys'
    @redis.set 'keys', parse_keys(@resources['keys_list'].get).to_json
  rescue URI::InvalidURIError
    Logger.error 'Failed to fetch keys: unable to talk with the remote server'
    abort
  end

  # fetch some portion of tokens data from the remote server
  def fetch_some_tokens
    @page += 1

    # GET /<tokens_list_url>?page=@page&per_page=@per_page
    response = @resources['tokens_list'].get page: @page, per_page: TOKENS_PER_PAGE

    parse_tokens(response).each { |token_data| Token.create token_data }
  rescue URI::InvalidURIError
    Logger.warn 'Failed to fetch tokens: unable to talk with the remote server'
  end

  def delete_token
    # DELETE /<delete_token_url>?token_data
    @resources['delete_token'].delete token_data
  rescue URI::InvalidURIError
    Logger.warn 'Failed to delete token: unable to talk with the remote server'
  end

  private

  def load_tokens
    (redis.keys 'token*').map { |token_string| token_string[/^token_(.*?)$/, 1] }
  end

  def load_keys
    JSON.parse @redis.get('keys')
  end

end
