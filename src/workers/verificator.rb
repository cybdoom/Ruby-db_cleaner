module Workers
  module Verificator
    def play_with token
      @adapter.update_status token
    end

    def reduce_results
      new_results = { 'good' => 0, 'suspicious' => 0, 'bad' => 0 }
      @results.each { |status| new_results[status] += 1 }
      @results = new_results
    end
  end
end
