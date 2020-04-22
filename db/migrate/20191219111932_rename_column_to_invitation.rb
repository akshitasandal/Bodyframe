class RenameColumnToInvitation < ActiveRecord::Migration[5.2]
  def change
    remove_column :invitations, :amount
    add_column :invitations, :amount, :decimal
  end
end
