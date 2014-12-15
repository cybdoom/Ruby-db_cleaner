require File.join %w(src environment)

require File.join %w(src settings)
require File.join %w(src logger)
require File.join %w(src models token)

results = { total: Token.count }
Token.each &:verify

Megalogger.info <<-MSG
Finished successfully
Results:
  Total;                #{ results[:total] }
  Valid:                #{ results[:valid] }
  Invalid:              #{ results[:invalid] }
  Marked for deletion:  #{ results[:marked] }
MSG

