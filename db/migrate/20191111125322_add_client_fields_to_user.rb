class AddClientFieldsToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :weight, :integer, default: 0
    add_column :users, :height, :integer, default: 0
    add_column :users, :objective, :integer, default: 0
  end
end
