class AddNewColumnToInvitation < ActiveRecord::Migration[5.2]
  def change
    rename_column :invitations, :amount, :monthly_amount
    add_column :invitations, :session_amount, :decimal
  end
end
