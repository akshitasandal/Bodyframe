class AddDeviceTypeToDeviceToken < ActiveRecord::Migration[5.2]
  def change
    add_column :device_tokens, :device_type, :string
  end
end
