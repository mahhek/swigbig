class AddSlugToBars < ActiveRecord::Migration
  def change
    #add_column :bars, :slug, :string
    add_index :bars, :slug
  end
end
