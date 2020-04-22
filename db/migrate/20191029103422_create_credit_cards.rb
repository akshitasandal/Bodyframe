class CreateCreditCards < ActiveRecord::Migration[5.2]
  def change
    create_table :credit_cards do |t|
      t.string :cc_number
      t.string :expiry
      t.string :cvv
      t.integer :user_id

      t.timestamps
    end
    add_index :credit_cards, :user_id
  end
end
