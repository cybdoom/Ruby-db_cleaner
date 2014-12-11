# Verifies tokens fetched from the remote server, deletes outdated tokens
class Worker
  def initialize key_data
    # for cloud services interaction
    # defines [:connect, :verify] methods
    require "adapters/#{key_data.platform.downcase}_adapter"
    include eval("Adapters::#{ key_data[:platform] }")
    # # # # # # # # # # # # # # # # # # #

    self.connect key_data

    # for fetching and deletiong tokens
    @data_manipulator = DataManipulator.new
  end

  def launch
    loop do
      rows = @data_manipulator.fetch_some_tokens
      rows.each { |row| @data_manipulator.delete_token(row) unless self.verify_token(row) }

      if rows.empty? || rows.size < DataManipulator::TOKENS_PER_PAGE
        break
      end
    end
  end

end
