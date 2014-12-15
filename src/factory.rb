require 'thread/pool'

require_relative 'data_manipulator'
require_relative 'worker'
require_relative File.join %w(models key)

# Rules workers lifecycle
class Factory
  def initialize
    @workers_pool = Thread.pool Settings.threads.workers
  end

  def launch
    # fetch keys data from the remote server
    @keys = Key.data_manipulator.fetch_keys

    # for each key fetched save it to our db, spawn ping worker and put it into @workers_pool
    @keys.each do |key|
      key = Key.create key
      results[:keys][:saved] += 1 if key.persisted?
      results[:keys][:valid] += 1 if key.connect
      @workers_pool.process(key) { |arg| spawn_worker(arg); }
    end
  end

  private

  def spawn_worker key
    Worker.new(key).launch
  end

end
