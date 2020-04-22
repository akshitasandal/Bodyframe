class AddColumnToWorkouts < ActiveRecord::Migration[5.2]
  def change
    add_column :workouts, :client_id, :integer
    add_column :workouts, :workout_category_id, :integer
  end
end
