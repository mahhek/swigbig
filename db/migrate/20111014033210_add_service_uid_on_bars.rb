class AddServiceUidOnBars < ActiveRecord::Migration
  def up
    add_column :bars, :service_uid, :string
  end

  def down
    remove_column(:bars, :service_uid)
  end
end
