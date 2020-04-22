class AddStatusToCreditCards < ActiveRecord::Migration[5.2]
  def change
    add_column :credit_cards, :status, :integer, default: 1
  end
end
