require 'settingslogic'

# Loads app config into global accessed object
class Settings < Settingslogic
  source File.join '..', '..', 'config.yml'

  # choose settings corresponding to the current environment
  namespace 'test'
end
