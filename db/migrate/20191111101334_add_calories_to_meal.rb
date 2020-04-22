class AddCaloriesToMeal < ActiveRecord::Migration[5.2]
  def change
    add_column :meals, :calories, :integer, default: 0
  end
end
