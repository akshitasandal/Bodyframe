class AddSessionCountToInvitation < ActiveRecord::Migration[5.2]
  def change
    add_column :invitations, :session_count, :integer
  end
end
