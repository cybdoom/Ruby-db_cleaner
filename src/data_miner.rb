class DataMiner
  def initialize config
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
    connection_config = Cleaner.config[:database]
    begin
      @mysql_client = Mysql2::Client.new({
        host: connection_config[:host],
        username: connection_config[:username],
        password: connection_config[:password],
        encoding: connection_config[:encoding],
        database: connection_config[:database],
      })
    rescue
      Cleaner.logger.error 'Cannot connect to mysql database. Please check config and mysql status'
      abort
    end
  end
end
