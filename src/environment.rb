ENVIRONMENTS = ['test', 'production']
DEFAULT_ENV = 'test'

ENVIRONMENT = ENVIRONMENTS.include?(ENV['ENV']) ? ENV['ENV'] : DEFAULT_ENV
STDOUT.puts "Run in #{ ENVIRONMENT } mode"
