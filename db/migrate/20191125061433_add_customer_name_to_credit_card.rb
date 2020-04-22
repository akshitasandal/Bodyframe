class AddCustomerNameToCreditCard < ActiveRecord::Migration[5.2]
  def change
    add_column :credit_cards, :customer_name, :string
  end
end
