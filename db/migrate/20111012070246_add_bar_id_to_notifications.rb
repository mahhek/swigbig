class AddBarIdToNotifications < ActiveRecord::Migration
  def change
    add_column :notifications, :bar_id, :integer
    add_index :notifications, :bar_id
  end
end
