# Verifies tokens fetched from the remote server, deletes outdated tokens
class Worker
  def initialize key
    # for cloud services interaction
    # defines [:connect, :verify] methods

    # # # # # # # # # # # # # # # # # # #

    self.connect key

    # for fetching and deletiong tokens
    @data_manipulator = DataManipulator.new
  end

  def launch
    loop do
      # get some tokens from the remote server and save them to our db
      @data_manipulator.fetch_some_tokens

      @tokens.each { |token| ping token }

      break if tokens_ran_out?
    end
  end

  private

  def tokens_ran_out?
    @tokens.empty? || @tokens.size < DataManipulator::TOKENS_PER_PAGE
  end

end
