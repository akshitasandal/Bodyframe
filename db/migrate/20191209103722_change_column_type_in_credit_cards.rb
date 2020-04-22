class ChangeColumnTypeInCreditCards < ActiveRecord::Migration[5.2]
  def change
    remove_column :credit_cards, :status
  end
end
