class RenameQbColumnInUser < ActiveRecord::Migration[5.2]
  def change
    rename_column :users, :qb_pass, :qbp_access_token
  end
end
