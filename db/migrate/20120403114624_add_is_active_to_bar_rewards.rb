class AddIsActiveToBarRewards < ActiveRecord::Migration
  def change
    add_column :bar_rewards, :is_active, :boolean
  end
end
