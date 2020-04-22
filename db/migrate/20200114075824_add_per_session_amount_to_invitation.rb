class AddPerSessionAmountToInvitation < ActiveRecord::Migration[5.2]
  def change
    add_column :invitations, :per_session_amount, :decimal
  end
end
