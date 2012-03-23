class AddIsAdminFieldToRewards < ActiveRecord::Migration
  def change
    add_column :rewards, :is_admin, :boolean
  end
end
