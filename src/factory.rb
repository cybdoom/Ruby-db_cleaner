require 'thread/pool'

require_relative File.join %w(. data_manipulator)
require_relative File.join %w(. worker)
require_relative File.join %w(. listener)


# Rules workers and listeners lifecycle
class Factory
  def initialize
    # for fetching keys data
    @data_manipulator = DataManipulator.new

    @workers_pool = Thread.pool Settings.threads.workers
    @listeners_pool = Thread.pool Settings.threads.listeners
  end

  def launch
    @keys = @data_manipulator.fetch_keys

    # spawn worker for each key through the pool
    @keys.each do |key_data|
      # spawn listener if needed
      @listeners_pool.process(key_data) { |arg| spawn_listener(arg); } if key_data[:platform] == 'APNS'

      @workers_pool.process(key_data) { |arg| spawn_worker(arg); }
    end
  end

  private

  def spawn_worker key_data
    Worker.new(key_data).launch
  end

  def spawn_listener key_data
    Listener.new(key_data).launch
  end
end
