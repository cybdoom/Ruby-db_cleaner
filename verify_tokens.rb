ENVIRONMENTS = ['test', 'production']
DEFAULT_ENV = 'test'

ENVIRONMENT = ENVIRONMENTS.include?(ENV['ENV']) ? ENV['ENV'] : DEFAULT_ENV
STDOUT.puts "Run in #{ ENVIRONMENT } mode"

require File.join %w(. src settings)
require File.join %w(. src data_manipulator)
require File.join %w(. src logger)
require File.join %w(. src models token)

Token.each &:verify

Logger.info "Finished successfully.\nTotal rows checked: #{ cleaner.results[:total] }\nDeleted: #{ cleaner.results[:deleted] }"

