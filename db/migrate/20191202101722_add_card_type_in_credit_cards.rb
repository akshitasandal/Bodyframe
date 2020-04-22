class AddCardTypeInCreditCards < ActiveRecord::Migration[5.2]
  def change
    add_column :credit_cards, :card_type, :string
  end
end
