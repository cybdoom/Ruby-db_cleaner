require File.join %w(. src environment)

require File.join %w(. src factory)
require File.join %w(. src settings)
require File.join %w(. src logger)

# connect to our db
ActiveRecord::Base.establish_connection Settings.database

results = {keys: {}, tokens: {}}

::Factory.new.launch

Megalogger.info <<-MSG
Finished successfully
Results:
  Keys:
    Fetched:  #{ results[:keys][:fetched] }
    Saved:    #{ results[:keys][:saved] }
    Valid:    #{ results[:keys][:valid] }
  Tokens:
    Fetched:  #{ results[:tokens][:fetched] }
    Saved:    #{ results[:tokens][:saved] }
    Pinged:   #{ results[:tokens][:pinged] }
MSG
