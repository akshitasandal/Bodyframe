class AddTrainerCouponCodeToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :trainer_coupon_code, :string 
  end
end
