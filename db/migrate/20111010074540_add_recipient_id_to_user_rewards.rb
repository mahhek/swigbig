class AddRecipientIdToUserRewards < ActiveRecord::Migration
  def change
    add_column :user_rewards, :recipient_id, :integer
    add_index :user_rewards, :recipient_id
  end
end
