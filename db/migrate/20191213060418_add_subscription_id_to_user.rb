class AddSubscriptionIdToUser < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :qb_id
    add_column :users, :subscription_id, :string
  end
end
