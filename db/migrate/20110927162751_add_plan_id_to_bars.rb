class AddPlanIdToBars < ActiveRecord::Migration
  def change
    add_column :bars, :plan_id, :integer
    add_index :bars, :plan_id
  end
end
