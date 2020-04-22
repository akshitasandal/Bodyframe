class RemoveColumnsFromUser < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :admin_request
    remove_column :users, :requested_amount
  end
end
