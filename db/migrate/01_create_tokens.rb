class CreateTokens < ActiveRecord::Migration
  def change
    create_table :tokens do |t|
      t.string :token
      t.string :provider_name
      t.string :provider_version
      t.string :device_id
      t.boolean :fresh

      t.references :key

      t.timestamps
    end

    add_index :tokens, :token, unique: true
  end
end
