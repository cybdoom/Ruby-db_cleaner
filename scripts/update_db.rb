require_relative File.join %w(.. src environment)
require_relative File.join %w(.. src settings)
require_relative File.join %w(.. src logger)
require_relative File.join %w(.. src models token)
require_relative File.join %w(.. src models key)

start_time = Time.now

# connect to our db
ActiveRecord::Base.establish_connection Settings.database

# update our keys and tokens database from the remote server
Megalogger.info 'Updating keys table...'
Key.update_from_remote

Megalogger.info 'Updating tokens table...'
Token.update_from_remote
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

Megalogger.db_update_report start_time
