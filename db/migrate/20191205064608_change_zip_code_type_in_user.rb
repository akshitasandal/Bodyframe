class ChangeZipCodeTypeInUser < ActiveRecord::Migration[5.2]
  def change
    change_column :users, :zipcode, :string
  end
end
