ENVIRONMENTS = ['test', 'production']
DEFAULT_ENV = 'test'

ENVIRONMENT = ENVIRONMENTS.include?(ENV['ENV']) ? ENV['ENV'] : DEFAULT_ENV
STDOUT.puts "Run in #{ ENVIRONMENT } mode"

require File.join %w(. src factory)

class Cleaner
  ROOT = File.dirname __FILE__

  def launch_factory
    ::Factory.new.launch
  end

  def results
    @results
  end

end

require File.join %w(. src settings)
require File.join %w(. src logger)

Cleaner.new.launch_factory

Logger.info "Finished successfully.\nTotal rows checked: #{ cleaner.results[:total] }\nDeleted: #{ cleaner.results[:deleted] }"
