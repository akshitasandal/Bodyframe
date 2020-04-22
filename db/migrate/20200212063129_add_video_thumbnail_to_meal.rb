class AddVideoThumbnailToMeal < ActiveRecord::Migration[5.2]
  def change
    add_column :meals, :video_thumbnail, :string
  end
end
