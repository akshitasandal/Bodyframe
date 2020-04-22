class AddUserTypeInInvitation < ActiveRecord::Migration[5.2]
  def change
    add_column :invitations, :user_type, :integer
  end
end
