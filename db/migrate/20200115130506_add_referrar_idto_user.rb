class AddReferrarIdtoUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :referrar_id , :integer
  end
end
