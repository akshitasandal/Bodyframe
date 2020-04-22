class RemoveColumnFromInvitation < ActiveRecord::Migration[5.2]
  def change
    remove_column :invitations, :amount
  end
end
