class ChangeColumnInUser < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :wallet_amount
    add_column :users, :wallet_amount, :string
  end
end
