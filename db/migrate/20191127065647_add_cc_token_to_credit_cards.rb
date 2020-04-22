class AddCcTokenToCreditCards < ActiveRecord::Migration[5.2]
  def change
    add_column :credit_cards, :cc_token, :string
  end
end
