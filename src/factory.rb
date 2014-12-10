require 'thread'

class Factory
  def initialize
    @data_mmanipulator = DataManipulator.new

    @workers_pool = Thread.pool Settings.workers].count
    @listeners_pool = Thread.pool Settings.workers].count
  end

  def launch
    @keys = @data_manipulator.fetch_keys

    @keys.each do |key_data|
      @listeners_pool.process(key_data) { |arg| spawn_listener(arg) } if key_data[:platform] == 'APNS'
      @workers_pool.process(key_data) { |arg| spawn_worker(arg) }
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
