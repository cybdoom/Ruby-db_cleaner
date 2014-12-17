require 'thread/pool'

require_relative 'worker'
require_relative File.join %w(models key)
require_relative File.join %w(models token)

# Rules workers lifecycle
class Factory
  def initialize
    @workers_pool = Thread.pool Settings.threads.workers
  end

  def launch
    Key.update_from_remote
    Token.update_from_remote

    # for each key fetched save it to our db, spawn worker and put it into @workers_pool
    Key.all.each do |key|
      begin
        tokens_data = key.tokens.as_json
        @workers_pool.process(key.as_json, tokens_data) { |key, tokens| spawn_worker(key, tokens) }
      rescue Exception => e
        Megalogger.warn "Worker was crashed\nException: #{ e.message }"
        Megalogger.warn e.backtrace
      end
    end
  end

  private

  def spawn_worker key_data, tokens_data
    Worker.new(key_data, tokens_data).launch
  end

end
