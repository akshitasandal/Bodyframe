class AddBankAccountIdToPaymentHistories < ActiveRecord::Migration[5.2]
  def change
    add_column :payment_histories, :bank_account_id, :integer
  end
end
