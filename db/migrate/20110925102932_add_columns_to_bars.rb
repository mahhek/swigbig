class AddColumnsToBars < ActiveRecord::Migration
  def change
    add_column :bars, :name, :string
    add_column :bars, :address, :string
    add_column :bars, :zip_code, :string
    add_column :bars, :phone_number, :string
    add_column :bars, :city, :string
    add_column :bars, :state_abbr, :string
    add_column :bars, :country_abbr, :string
    add_column :bars, :lat, :string
    add_column :bars, :lng, :string
    add_column :bars, :logo_file_name, :string
    add_column :bars, :logo_content_type, :string
    add_column :bars, :logo_file_size, :integer
    add_column :bars, :logo_updated_at, :datetime
    add_column :bars, :slug, :string
  end
end
