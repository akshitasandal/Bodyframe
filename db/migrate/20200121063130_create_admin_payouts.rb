class CreateAdminPayouts < ActiveRecord::Migration[5.2]
  def change
    create_table :admin_payouts do |t|
      t.integer :user_id
      t.string :amount_requested
      t.integer :payment, default: 1
      t.timestamps
    end
  end
end
