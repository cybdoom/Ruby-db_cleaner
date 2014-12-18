require_relative File.join %w(models token)

# Pings tokens fetched from the remote server
class Worker
  def initialize key_data, tokens_data, behavior
    @key = key_data
    @tokens = tokens_data

    # plug in adapter
    relative_path = File.join '.', 'src', 'adapters', "#{key_data['platform'].downcase}_adapter"
    require relative_path
    @adapter = eval("Adapters::#{ key_data['platform'] }").new
    # # # # # # # # #

    # set behavior
    @behavior = behavior
    relative_path = File.join '.', 'src', 'workers', @behavior.to_s
    require relative_path
    self.class.send(:include, eval("Workers::#{ @behavior.capitalize }"))
    # # # # # # # # #
  end

  def launch
    @results = @tokens.map { |token| play_with token }
    reduce_results
  end
end
