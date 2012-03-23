class RemoveFieldActiveFromBars < ActiveRecord::Migration
  def change
    remove_column :bars, :active
    add_column :bars, :status, :string, :default => "inactive"
  end
end
