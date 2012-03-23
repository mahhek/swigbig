class AddNotifierTypeToNotifications < ActiveRecord::Migration
  def change
    add_column :notifications, :notifier_type, :string
  end
end
