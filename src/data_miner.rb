class DataMiner
  def initialize
    connect_to_db
  end

  def mine
    # stub
    {
      '1234567890' => { a: 1, b: 2 },
      '9876543210' => { a: 2, b: 3 }
    }
  end

  private

  def connect_to_db
    begin
      @mysql_client = Mysql2::Client.new({
        host: Settings.database.host,
        username: Settings.database.username,
        password: Settings.database.password,
        encoding: Settings.database.encoding,
        database: Settings.database.name
      })
    rescue
      Cleaner.logger.error 'Cannot connect to mysql database. Please check config and mysql status'
      abort
    end
  end
end
