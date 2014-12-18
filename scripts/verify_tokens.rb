require_relative File.join %w(.. src environment)
require_relative File.join %w(.. src settings)
require_relative File.join %w(.. src factory)
require_relative File.join %w(.. src logger)

# connect to our db
ActiveRecord::Base.establish_connection Settings.database

verification_factory = Factory.new
Megalogger.info 'Launching verificators factory...'
verification_factory.launch :verificator
Megalogger.factory_work_report verification_factory
