# Pings tokens fetched from the remote server
class Worker
  def initialize key
    @data_manipulator = DataManipulator.new
  end

  def launch
    loop do
      # get some tokens from the remote server, ping them and save to our db
      @tokens = @data_manipulator.fetch_some_tokens

      @tokens.each do |token|
        key = Key.find_by_platform_and_application_version token.provider_name, token.provider_version
        if key.nil?
          Megalogger.warn "Unknown token key, failed to save to db"
        else
          token = Token.create(token.merge(key_id: key.id))
          $results[:tokens][:saved] += 1 if token.persisted?
          $results[:tokens][:pinged] += 1 if token.ping
        end
      end

      break if tokens_ran_out?
    end
  end

  private

  def tokens_ran_out?
    @tokens.empty? || @tokens.size < DataManipulator::TOKENS_PER_PAGE
  end

end
