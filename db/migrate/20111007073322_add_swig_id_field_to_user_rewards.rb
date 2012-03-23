class AddSwigIdFieldToUserRewards < ActiveRecord::Migration
  def change
    add_column :user_rewards, :swig_id, :integer
    add_index :user_rewards, :swig_id
  end
end
