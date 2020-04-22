class AddCoulumnToUserTable < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :qb_pass, :string
  end
end
