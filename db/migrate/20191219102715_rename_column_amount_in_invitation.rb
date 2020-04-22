class RenameColumnAmountInInvitation < ActiveRecord::Migration[5.2]
  def change
    change_column :invitations, :amount, :string
  end
end
