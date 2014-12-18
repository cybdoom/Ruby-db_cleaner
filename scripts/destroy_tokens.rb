require_relative File.join %w(.. src environment)
require_relative File.join %w(.. src settings)
require_relative File.join %w(.. src logger)
require_relative File.join %w(.. src models token)

# connect to our db
ActiveRecord::Base.establish_connection Settings.database
