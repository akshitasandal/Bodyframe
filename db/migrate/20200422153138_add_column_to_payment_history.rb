class AddColumnToPaymentHistory < ActiveRecord::Migration[5.2]
  def change
    add_column :payment_histories, :reward_to_trainer, :string
  end
end
