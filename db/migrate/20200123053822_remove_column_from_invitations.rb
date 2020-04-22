class RemoveColumnFromInvitations < ActiveRecord::Migration[5.2]
  def change
    remove_column :invitations, :client_id, :integer
  end
end
