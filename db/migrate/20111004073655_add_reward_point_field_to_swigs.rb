class AddRewardPointFieldToSwigs < ActiveRecord::Migration
  def change
    add_column :swigs, :reward_point, :integer
  end
end
