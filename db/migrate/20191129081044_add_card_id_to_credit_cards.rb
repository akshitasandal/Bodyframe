class AddCardIdToCreditCards < ActiveRecord::Migration[5.2]
  def change
    add_column :credit_cards, :card_id, :string
  end
end
