class AddClientIdToPaymentHistory < ActiveRecord::Migration[5.2]
  def change
    add_column :payment_histories, :client_id, :integer
  end
end
