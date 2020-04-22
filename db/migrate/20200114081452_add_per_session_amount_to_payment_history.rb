class AddPerSessionAmountToPaymentHistory < ActiveRecord::Migration[5.2]
  def change
    add_column :payment_histories, :per_session_amount, :decimal
  end
end
