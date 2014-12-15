environments =  ['test', 'production']
default_env  =  'test'
given_env    =  ENV['RACK_ENV'] || ENV['ENV'] || ENV['ENVIRONMENT']

ENVIRONMENT = environments.include?(given_env) ? given_env : default_env
STDOUT.puts "Run in #{ ENVIRONMENT } mode"
