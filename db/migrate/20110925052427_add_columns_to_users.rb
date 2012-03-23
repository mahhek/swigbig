class AddColumnsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :name, :string
    add_column :users, :address, :string
    add_column :users, :zip_code, :string
    add_column :users, :phone_number, :string
    add_column :users, :city, :string
    add_column :users, :state_abbr, :string
    add_column :users, :country_abbr, :string
  end
end
