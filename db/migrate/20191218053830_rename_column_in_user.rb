class RenameColumnInUser < ActiveRecord::Migration[5.2]
  def change
    rename_column :users, :firebase_id, :qb_id
  end
end
