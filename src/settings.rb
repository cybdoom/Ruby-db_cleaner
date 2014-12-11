require 'settingslogic'

# Loads app config into global accessed object
class Settings < Settingslogic
  source 'config.yml'

  # choose settings corresponding to the current environment
  namespace ENVIRONMENT
end
