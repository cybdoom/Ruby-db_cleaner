class CreateKeys < ActiveRecord::Migration
  def change
    create_table :keys do |t|
      t.string :key_data
      t.string :application_version
      t.string :platform

      t.timestamps
    end

    add_index :keys, [:platform, :application_version], unique: true
  end
end
