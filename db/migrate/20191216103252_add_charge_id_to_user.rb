class AddChargeIdToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :charge_id, :string
  end
end
