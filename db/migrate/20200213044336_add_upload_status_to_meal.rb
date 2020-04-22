class AddUploadStatusToMeal < ActiveRecord::Migration[5.2]
  def change
    add_column :meals, :upload_status, :boolean, default: false
  end
end
