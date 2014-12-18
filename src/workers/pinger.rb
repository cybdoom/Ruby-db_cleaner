module Workers
  module Pinger
    def play_with token
      @adapter.ping token
    end

    def reduce_results
      new_results = { 'pinged' => 0 }
      @results.each { |success| new_results['pinged'] += 1 if success }
      @results = new_results
    end
  end
end
