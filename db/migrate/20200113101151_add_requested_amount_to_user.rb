class AddRequestedAmountToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :requested_amount, :string
  end
end
