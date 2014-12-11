module Adapters
  module GCM
    def initialize_connection key_data
      @connection = GCM.new(
      # ...
      )
    end

    def verify_token token_data
      # stub
      true
    end
  end
end
