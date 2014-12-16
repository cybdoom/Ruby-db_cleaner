require 'active_record'

require_relative File.join %w(src environment)
require_relative File.join %w(src settings)

namespace :db do
  desc 'Connect to database server'
  task :environment do
    ActiveRecord::Base.establish_connection Settings.database
  end

  desc 'Create database'
  task :create do
    ActiveRecord::Base.establish_connection Settings.database.merge('database' => nil)
    ActiveRecord::Base.connection.create_database Settings.database.database
  end

  desc 'Migrate the database'
  task :migrate => :environment do
    MIGRATIONS_PATH = File.join File.dirname(__FILE__), %w(db migrate)

    ActiveRecord::Migration.verbose = true
    ActiveRecord::Migrator.migrate MIGRATIONS_PATH, ENV['VERSION'] ? ENV['VERSION'].to_i : nil
  end

  desc 'Drop the database'
  task :drop => :environment do
    ActiveRecord::Base.connection.drop_database Settings.database.database
  end

  desc 'Cleans data tables'
  task :clean => :environment do
    connection = ActiveRecord::Base.connection
    tables = connection.execute("SHOW TABLES").map { |r| r[0] }
    tables.each { |t| connection.execute("TRUNCATE `#{t}`") }
  end
end
