class RemoveCategoryFromWorkoutAndMeal < ActiveRecord::Migration[5.2]
  def change
    remove_column :workouts, :category, :string
    remove_column :meals, :category, :string
  end
end
