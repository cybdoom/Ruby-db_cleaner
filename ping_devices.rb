require_relative File.join %w(src environment)
require_relative File.join %w(src settings)
require_relative File.join %w(src factory)
require_relative File.join %w(src logger)

# connect to our db
ActiveRecord::Base.establish_connection Settings.database

pingers_factory = ::Factory.new
Megalogger.info 'Launching pingers factory...'
pingers_factory.launch :pinger
Megalogger.factory_work_report pingers_factory
