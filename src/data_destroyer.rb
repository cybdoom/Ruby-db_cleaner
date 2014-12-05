class DataDestroyer
  include Singleton

  def mark_for_destroy record
    @for_destroy << record
  end

  def destroy_all
    @for_destroy.each {  }
  end
end
