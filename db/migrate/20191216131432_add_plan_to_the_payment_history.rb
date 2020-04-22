class AddPlanToThePaymentHistory < ActiveRecord::Migration[5.2]
  def change
    add_column :payment_histories, :plan, :string
  end
end
