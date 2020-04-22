class AddNextPayableDateToPaymentHistory < ActiveRecord::Migration[5.2]
  def change
    add_column :payment_histories, :next_payable_date, :datetime
  end
end
