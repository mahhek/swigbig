class AddGmapsToBars < ActiveRecord::Migration
  def change
    rename_column :bars, :lat, :latitude
    rename_column :bars, :lng, :longitude
    change_column :bars, :latitude, :float
    change_column :bars, :longitude, :float
    add_column :bars, :gmaps, :boolean
  end
end
