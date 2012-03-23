class AddRewardPointFieldToRewards < ActiveRecord::Migration
  def change
    add_column :rewards, :reward_point, :integer, :default => 0
  end
end
