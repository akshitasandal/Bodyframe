class AddColumnInPaymentHistory < ActiveRecord::Migration[5.2]
  def change
    remove_column :payment_histories, :amount
    add_column :payment_histories, :amount, :decimal
  end
end
