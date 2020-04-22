class AddQbIdToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :qb_id, :string
  end
end
