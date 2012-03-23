class AddOpenedCountFieldToBarDeals < ActiveRecord::Migration
  def change
    add_column :bar_deals, :opened_count, :integer, :default => 0
  end
end
