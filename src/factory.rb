require 'thread/pool'

require_relative File.join %w(. data_manipulator)
require_relative File.join %w(. worker)

# Rules workers lifecycle
class Factory
  def initialize
    # for fetching keys data
    @data_manipulator = DataManipulator.new

    @workers_pool = Thread.pool Settings.threads.workers
  end

  def launch
    @keys = @data_manipulator.fetch_keys

    # for each key spawn worker and put it into @workers_pool
    @keys.each { |key| @workers_pool.process(key) { |arg| spawn_worker(arg); } }
  end

  private

  def spawn_worker key
    Worker.new(key).launch
  end

end
