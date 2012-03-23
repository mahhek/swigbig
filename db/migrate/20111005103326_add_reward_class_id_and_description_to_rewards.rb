class AddRewardClassIdAndDescriptionToRewards < ActiveRecord::Migration
  def change
    add_column :rewards, :reward_class_id, :integer
    add_column :rewards, :description, :text
    add_index :rewards, :reward_class_id
  end
end
