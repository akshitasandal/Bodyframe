class AddUploadStatusToWorkout < ActiveRecord::Migration[5.2]
  def change
    add_column :workouts, :upload_status, :boolean, default: false
  end
end
