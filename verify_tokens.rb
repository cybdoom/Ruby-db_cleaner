require File.join %w(src environment)

require File.join %w(src settings)
require File.join %w(src logger)
require File.join %w(src models token)

# connect to our db
ActiveRecord::Base.establish_connection Settings.database

$results = { total: Token.count }

# verify each token stored in our db
Token.each &:verify

Megalogger.info <<-MSG
Finished successfully
Results:
  Total:                #{ $results[:total] }
  Valid:                #{ $results[:valid] }
  Invalid:              #{ $results[:invalid] }
  Marked for deletion:  #{ $results[:marked] }
MSG

