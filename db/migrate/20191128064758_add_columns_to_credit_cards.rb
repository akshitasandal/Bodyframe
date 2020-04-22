class AddColumnsToCreditCards < ActiveRecord::Migration[5.2]
  def change
    add_column :credit_cards, :country, :string
    add_column :credit_cards, :zipcode, :integer
  end
end
