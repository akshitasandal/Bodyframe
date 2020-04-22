class AddSourceIdToBankAccounts < ActiveRecord::Migration[5.2]
  def change
    add_column :bank_accounts, :source_id, :string
  end
end
