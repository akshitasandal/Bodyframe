class AddVideoUrlToWorkout < ActiveRecord::Migration[5.2]
  def change
    add_column :workouts, :video_url, :string
  end
end
