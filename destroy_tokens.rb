require_relative File.join %w(src environment)
require_relative File.join %w(src settings)
require_relative File.join %w(src logger)
require_relative File.join %w(src models token)

# connect to our db
ActiveRecord::Base.establish_connection Settings.database

$results = {
  tokens: {
    total: Token.count,
    destroyed: 0
  },
  start_time: Time.now
}
Token.invalid.each &:destroy

Megalogger.info <<-MSG
Finished successfully
Results:
  Tokens:
    Total:      #{ $results[:tokens][:total] }
    Destroyed:  #{ $results[:tokens][:destroyed] }
  Time:         #{ Time.now - $results[:start_time] }
MSG
