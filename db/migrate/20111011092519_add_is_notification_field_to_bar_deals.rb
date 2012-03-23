class AddIsNotificationFieldToBarDeals < ActiveRecord::Migration
  def change
    add_column :bar_deals, :is_notification, :boolean, :default => false
  end
end
