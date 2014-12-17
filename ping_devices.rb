require File.join %w(. src environment)

require File.join %w(. src settings)
require File.join %w(. src factory)
require File.join %w(. src logger)

# connect to our db
ActiveRecord::Base.establish_connection Settings.database

$results = {
  keys: {
    fetched:  0,
    saved:    0,
  },
  tokens: {
    fetched:  0,
    saved:    0,
    pinged:   0
  },
  start_time: Time.now
}

::Factory.new.launch

Megalogger.info <<-MSG
Finished successfully
Results:
  Keys:
    Fetched:  #{ $results[:keys][:fetched] }
    Saved:    #{ $results[:keys][:saved] }
  Tokens:
    Fetched:  #{ $results[:tokens][:fetched] }
    Saved:    #{ $results[:tokens][:saved] }
    Pinged:   #{ $results[:tokens][:pinged] }
  Time:       #{ Time.now - $results[:start_time] }
MSG
