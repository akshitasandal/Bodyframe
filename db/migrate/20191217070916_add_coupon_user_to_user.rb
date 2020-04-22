class AddCouponUserToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :coupon_used, :boolean, default: false
  end
end
