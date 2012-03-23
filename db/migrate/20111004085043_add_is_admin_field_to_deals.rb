class AddIsAdminFieldToDeals < ActiveRecord::Migration
  def change
    add_column :deals, :is_admin, :boolean
  end
end
