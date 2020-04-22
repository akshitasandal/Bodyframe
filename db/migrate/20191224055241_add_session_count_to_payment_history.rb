class AddSessionCountToPaymentHistory < ActiveRecord::Migration[5.2]
  def change
    add_column :payment_histories, :session_count, :integer
  end
end
