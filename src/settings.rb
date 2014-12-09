class Settings < SettingsLogic
  source File.join(Cleaner::ROOT, 'config.yml')
  namespace Cleaner.env
end
