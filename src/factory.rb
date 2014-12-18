require 'thread/pool'
require 'thread/future'

require_relative 'worker'
require_relative File.join %w(models key)
require_relative File.join %w(models token)

# Rules workers lifecycle
class Factory
  attr_reader :launched_at, :closed_at, :results

  def initialize
    @workers_pool = Thread.pool Settings.threads.workers
  end

  def launch behavior
    @launched_at = Time.now
    futures = Key.all.map do |key|
      tokens_data = key.tokens.as_json
      ~Thread.future(@workers_pool) { spawn_worker(key.as_json, tokens_data, behavior) }
    end

    @results = {}
    if futures.to_a.any?
      futures.first.each_key { |key| @results[key] = 0 }
      futures.each { |hash| @results.merge!(hash) {|_, v1, v2| v1 + v2 } }
    end

    @closed_at = Time.now
  end

  private

  def spawn_worker key_data, tokens_data, behavior
    Worker.new(key_data, tokens_data, behavior).launch
  end

end
