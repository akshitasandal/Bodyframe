class ChangeColumnInUsers < ActiveRecord::Migration[5.2]
  def change
    change_column :users, :height, :string
    change_column :users, :weight, :string
  end
end
