class AddEmailToInvitation < ActiveRecord::Migration[5.2]
  def change
    add_column :invitations, :email, :string
  end
end
