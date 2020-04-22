class AddDoneToWorkoutAndMeal < ActiveRecord::Migration[5.2]
  def change
    add_column :workouts, :done, :boolean, default: false
    add_column :meals, :done, :boolean, default: false
  end
end
