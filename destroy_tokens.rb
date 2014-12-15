require File.join %w(src environment)
require File.join %w(src settings)

require File.join %w(src models token)

# connect to our db
ActiveRecord::Base.establish_connection Settings.database

Token.invalid.each &:destroy
