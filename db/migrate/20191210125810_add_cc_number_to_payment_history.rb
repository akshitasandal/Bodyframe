class AddCcNumberToPaymentHistory < ActiveRecord::Migration[5.2]
  def change
    add_column :payment_histories, :cc_number, :string
  end
end
