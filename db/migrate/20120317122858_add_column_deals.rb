class AddColumnDeals < ActiveRecord::Migration
  def up
    add_column :deals, :deal_type_id, :integer
  end

  def down
    remove_column :deals, :deal_type_id
  end
end
