class AddVideoThumbnailToWorkout < ActiveRecord::Migration[5.2]
  def change
    add_column :workouts, :video_thumbnail, :string
  end
end
