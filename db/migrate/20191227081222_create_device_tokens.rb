class CreateDeviceTokens < ActiveRecord::Migration[5.2]
  def change
    create_table :device_tokens do |t|
      t.integer :user_id
      t.string :device_token
      t.timestamps
    end
  end
end
