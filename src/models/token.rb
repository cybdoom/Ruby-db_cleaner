class Token < ActiveRecord::Base
  @@data_manipulator = DataManiplator.new

  before_destroy { @@data_manipulator.delete_token self.to_json }

  def verify
    @@
  end
end
