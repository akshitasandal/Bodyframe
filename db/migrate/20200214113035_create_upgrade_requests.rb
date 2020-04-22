class CreateUpgradeRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :upgrade_requests do |t|
      t.integer :client_id
      t.integer :user_id
      t.integer :plan
      t.decimal :monthly_amount
      t.decimal :session_amount
      t.integer :session_count
      t.decimal :per_session_amount
      t.integer :status, default: 0
      t.timestamps
    end
  end
end
