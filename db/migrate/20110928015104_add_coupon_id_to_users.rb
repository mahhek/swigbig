class AddCouponIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :coupon_id, :integer
    add_index :users, :coupon_id
  end
end
