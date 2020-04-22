class CreatePaymentHistories < ActiveRecord::Migration[5.2]
  def change
    create_table :payment_histories do |t|
      t.decimal :amount, precision: 5, scale: 2
      t.integer :credit_card_id
      t.integer :user_id
      t.timestamps
    end
  end
end
