class AddWalletAmountToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :wallet_amount, :decimal, precision: 5, scale: 2
  end
end
