class AddColumnToNotification < ActiveRecord::Migration[5.2]
  def change
    add_column :notifications, :meal_id, :integer
    add_column :notifications, :workout_id, :integer
  end
end
