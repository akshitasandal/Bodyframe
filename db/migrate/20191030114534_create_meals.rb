class CreateMeals < ActiveRecord::Migration[5.2]
  def change
    create_table :meals do |t|
      t.string :title
      t.text :description
      t.string :category
      t.datetime :meal_time
      t.integer :protein
      t.integer :carbs
      t.integer :fat
      t.string :file
      t.integer :user_id

      t.timestamps
    end
  end
end
