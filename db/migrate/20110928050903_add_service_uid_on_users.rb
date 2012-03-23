class AddServiceUidOnUsers < ActiveRecord::Migration
  def change
    add_column :users, :service_uid, :string
    add_index :users, :service_uid
  end
end
