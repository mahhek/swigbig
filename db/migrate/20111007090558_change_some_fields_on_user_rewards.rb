class ChangeSomeFieldsOnUserRewards < ActiveRecord::Migration
  def up
    add_column :user_rewards, :total, :integer
    change_column :user_rewards, :earned, :integer
    remove_column :user_rewards, :user_id
  end

  def down
    remove_column :user_rewards, :total
    change_column :user_rewards, :earned, :boolean
    add_column :user_rewards, :user_id, :integer
  end
end
