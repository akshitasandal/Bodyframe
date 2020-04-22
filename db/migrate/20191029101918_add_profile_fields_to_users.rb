class AddProfileFieldsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :full_name, :string
    add_column :users, :dob, :date
    add_column :users, :address, :text
    add_column :users, :phone, :string
    add_column :users, :stripe_id, :string
    add_column :users, :sex, :integer
    add_column :users, :avatar, :string
    add_column :users, :user_type, :integer
    add_column :users, :firebase_id, :string
    add_column :users, :country_code, :string
  end
end
