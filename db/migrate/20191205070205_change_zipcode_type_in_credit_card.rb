class ChangeZipcodeTypeInCreditCard < ActiveRecord::Migration[5.2]
  def change
    change_column :credit_cards, :zipcode, :string
  end
end
