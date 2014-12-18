require 'logging'
require 'forwardable'

# Logs worflow process
module Megalogger
  PATH = File.expand_path 'logs'
  # for delegating module methods calls to @logger instance
  extend SingleForwardable
  def_delegators :@logger, :info, :warn, :error
  # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

  @logger = Logging.logger('cleaner_db')

  # configure logging to stdout
  @logger.add_appenders Logging.appenders.stdout if ::Settings.log.stream.stdout

  # configure logging to files
  ::Settings.log.stream.files.each do |file_name|
    path_to_file = File.join PATH, file_name
    begin
      @logger.add_appenders Logging.appenders.file(path_to_file)
      STDOUT.puts "Logs will be written to the file: #{ path_to_file }"
    rescue
      STDOUT.puts "Problems with log file path specified in configs: #{ path_to_file }\nLogs will not be written to this file"
    end
  end if ::Settings.log.stream.files

  def self.factory_work_report factory
    message = "Finished successfully!\nResults:"
    factory.results.each { |key, value| message += "\n  #{ key.capitalize }:  #{ value }" }
    message += "\n  Time:  #{ factory.closed_at - factory.launched_at }"
    @logger.info message
  end

  def self.db_update_report start_time
    message = <<-MSG
Finished successfully!
Results:
  Updated:     #{ Key.since(start_time).count + Token.since(start_time).count }
    Keys:      #{ Key.since(start_time).count }
    Tokens:    #{ Token.since(start_time).count }
  Time:        #{ Time.now - start_time }
MSG

    @logger.info message
  end

end
