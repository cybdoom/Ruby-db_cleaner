class Worker
  def initialize key_data
    self.class.include eval("Adapters::#{ key_data[:platform] }")
    self.initialize_connection key_data
    @data_manipulator = DataManipulator.new
  end

  def launch
    loop
      rows = @data_manipulator.fetch_some_tokens
      rows.each { |row| @data_manipulator.delete_token(row) unless self.verify_token(row) }

      break if rows.empty? || rows.size < DataManipulator::TOKENS_PER_PAGE
    end
  end
end
