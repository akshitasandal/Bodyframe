class CreateBankAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :bank_accounts do |t|
      t.string :name
      t.string :bank_name
      t.string :routing_number
      t.string :account_number
      t.integer :user_id

      t.timestamps
    end
  end
end
