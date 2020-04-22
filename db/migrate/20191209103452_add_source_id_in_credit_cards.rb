class AddSourceIdInCreditCards < ActiveRecord::Migration[5.2]
  def change
    add_column :credit_cards, :source_id, :string
  end
end
