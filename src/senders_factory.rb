require 'thread'

class SendersFactory
  def initialize data
    @data = data # Hash { key: row }
    @thread_pool = Thread.pool Cleaner.config[:workers][:count]
  end

  def launch
    @data.each do |key, row|
      service = detect_service row
      @thread_pool.process &:invoke_sender
    end
  end

  private

  def detect_service row
    # stub
    'GCM'
  end

  def invoke_sender

  end
end
