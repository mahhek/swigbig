class AddColumnActiveToBars < ActiveRecord::Migration
  def change
    add_column :bars, :active, :boolean, :default => false
  end
end
