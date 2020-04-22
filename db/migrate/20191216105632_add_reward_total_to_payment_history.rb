class AddRewardTotalToPaymentHistory < ActiveRecord::Migration[5.2]
  def change
    add_column :payment_histories, :reward_total, :decimal
  end
end
