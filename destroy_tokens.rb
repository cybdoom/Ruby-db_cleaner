require File.join %w(src environment)

require File.join %w(src models token)

Token.invalid.each &:destroy
