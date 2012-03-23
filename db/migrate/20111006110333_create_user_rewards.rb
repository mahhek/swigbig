class CreateUserRewards < ActiveRecord::Migration
  def change
    create_table :user_rewards do |t|
      t.integer :user_id
      t.integer :reward_id
      t.boolean :earned, :default => false

      t.timestamps
    end
    add_index :user_rewards, [:user_id, :reward_id]
  end
end
