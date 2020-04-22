class AddPaymentHistoryIdToAdminPayout < ActiveRecord::Migration[5.2]
  def change
    add_column :payment_histories, :admin_payout_id, :integer
  end
end
