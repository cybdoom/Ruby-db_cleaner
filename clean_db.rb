require 'yaml'
require 'logging'

class Cleaner
  ROOT = File.dirname __FILE__
  CONFIG_PATH = File.join ROOT, 'config.yml'
  ENVIRONMENTS = [:test, :production]
  DEFAULT_ENVIRONMENT = :test
  LOGS_PATH = File.join ROOT, 'logs'

  def initialize env
    @env = ENVIRONMENTS.include? env ? env : DEFAULT_ENVIRONMENT
    STDOUT.puts "Run in #{ @env } mode"

    load_config

    configure_logger
  end

  def gather_data
    @data_miner = DataMiner.new @config
    @data = @data_miner.mine
  end

  def launch_factory
    Factory.new(self, @data).launch
  end

  def self.logger
    @@logger
  end

  def self.config
    @@config
  end

  def results
    @results
  end

  private

  def load_config
    File.open(CONFIG_PATH, 'r') { |file_stream| @@config = YAML.load(file_stream)[@env] }
  rescue Exception => e
    STDOUT.puts 'Wrong config file was given. Please check if config file exists and is valid'
    abort
  end

  def configure_logger
    @@logger = Logging.logger('cleaner_logger')
    logger_config = @config[:log]
    @@logger.add_appenders Logging.appenders.stdout if logger_config[:stream][:stdout]
    logger_config[:files].each do |file_name|
      path_to_file = File.join LOGS_PATH, file_name
      begin
        @@logger.add_appenders Logging.appenders.file(path_to_file)
        STDOUT.puts "Logs will be written to the file: #{ path_to_file }"
      rescue
        STDOUT.puts "Problems with log file path specified in configs: #{ path_to_file }\nLogs will not be written to this file"
      end
    end if logger_config[:files]
  end
end

cleaner = Cleaner.new :test
cleaner.gather_data
cleaner.launch_factory

Cleaner.logger.log "Finished successfully.\nTotal rows checked: #{ cleaner.results[:total] }\nDeleted: #{ cleaner.results[:deleted] }"
