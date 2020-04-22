class AddAdminRequestToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :admin_request, :boolean, default: false
  end
end
