class AddDefaultToCreditCard < ActiveRecord::Migration[5.2]
  def change
    add_column :credit_cards, :default, :boolean, default: false
  end
end
