class CreateInvitations < ActiveRecord::Migration[5.2]
  def change
    create_table :invitations do |t|
      t.string :full_name
      t.string :phone
      t.decimal :amount, precision: 5, scale: 2
      t.integer :client_id
      t.integer :trainer_id
      t.integer :plan

      t.timestamps
    end
    add_index :invitations, :client_id
    add_index :invitations, :trainer_id
  end
end
