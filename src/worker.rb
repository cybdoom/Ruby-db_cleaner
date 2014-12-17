require_relative File.join %w(models token)

# Pings tokens fetched from the remote server
class Worker
  def initialize key_data, tokens_data
    @key = key_data
    @tokens = tokens_data

    relative_path = File.join '.', 'src', 'adapters', "#{key_data['platform'].downcase}_adapter"
    require relative_path
    @adapter = eval("Adapters::#{ key_data['platform'] }").new
  end

  def launch
    @tokens.each { |token| $results[:tokens][:pinged] += 1 if @adapter.ping token }
  end
end
