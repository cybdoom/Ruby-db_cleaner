class DataDestroyer
  include Singleton

  def initialize data
    @data = data
  end

  def mark_for_destroy record_id
    @data[record_id][:outdated] = true
  end

  def destroy_all
  end
end
