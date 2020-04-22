class CreateWorkouts < ActiveRecord::Migration[5.2]
  def change
    create_table :workouts do |t|
      t.string :title
      t.text :description
      t.string :category
      t.integer :workout_duration
      t.string :calories_burned
      t.string :file
      t.integer :user_id

      t.timestamps
    end
  end
end
