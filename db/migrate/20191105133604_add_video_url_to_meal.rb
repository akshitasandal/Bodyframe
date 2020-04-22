class AddVideoUrlToMeal < ActiveRecord::Migration[5.2]
  def change
    add_column :meals, :video_url, :string
  end
end
