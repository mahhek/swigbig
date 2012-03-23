class AddIsActiveFieldToBarDeals < ActiveRecord::Migration
  def change
    add_column :bar_deals, :is_active, :boolean, :default => false
  end
end
