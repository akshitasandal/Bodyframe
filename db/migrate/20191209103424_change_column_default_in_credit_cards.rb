class ChangeColumnDefaultInCreditCards < ActiveRecord::Migration[5.2]
  def change
    rename_column :credit_cards, :default, :status
  end
end
