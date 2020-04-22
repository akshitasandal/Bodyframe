class AddDateToWorkout < ActiveRecord::Migration[5.2]
  def change
    add_column :workouts, :date, :date
    add_index :workouts, :date
  end
end
