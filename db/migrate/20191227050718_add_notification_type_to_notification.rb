class AddNotificationTypeToNotification < ActiveRecord::Migration[5.2]
  def change
    add_column :notifications, :notification_type, :integer
  end
end
