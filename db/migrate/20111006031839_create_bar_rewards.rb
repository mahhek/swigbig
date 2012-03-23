class CreateBarRewards < ActiveRecord::Migration
  def change
    create_table :bar_rewards do |t|
      t.integer :bar_id
      t.integer :reward_id

      t.timestamps
    end
    add_index :bar_rewards, [:bar_id, :reward_id]
  end
end
