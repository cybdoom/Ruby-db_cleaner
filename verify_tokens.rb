require_relative File.join %w(src environment)
require_relative File.join %w(src settings)
require_relative File.join %w(src logger)
require_relative File.join %w(src models token)

# connect to our db
ActiveRecord::Base.establish_connection Settings.database

$results = {
  tokens: {
    total:       Token.count,
    fresh:       0,
    outdated:     0,
    marked:      0
  },
  start_time:  Time.now
}

# verify each token stored in our db
Token.all.each &:verify

Megalogger.info <<-MSG
Finished successfully
Results:
  Tokens:
    Total:                #{ $results[:tokens][:total] }
    Valid:                #{ $results[:tokens][:fresh] }
    Invalid:              #{ $results[:tokens][:outdated] }
    Marked for deletion:  #{ $results[:tokens][:marked] }
  Time:                   #{ Time.now - $results[:start_time] }
MSG
