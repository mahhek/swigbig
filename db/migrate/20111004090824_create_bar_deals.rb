class CreateBarDeals < ActiveRecord::Migration
  def change
    create_table :bar_deals do |t|
      t.integer :bar_id
      t.integer :deal_id

      t.timestamps
    end
    add_index :bar_deals, [:bar_id, :deal_id]
  end
end
