require_relative File.join %w(models token)

# Pings tokens fetched from the remote server
class Worker
  def initialize key
    puts 'before tokens method'
    puts key
    begin
      key.tokens
    rescue
      puts 'some error while searching tokens'
    end
    puts 'after tokens method'
  end

  def launch
    @tokens.each &:ping
  end
end
