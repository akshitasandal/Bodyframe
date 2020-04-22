class AddColumnToMeals < ActiveRecord::Migration[5.2]
  def change
    add_column :meals, :client_id, :integer
    add_column :meals, :meal_category_id, :integer
  end
end
