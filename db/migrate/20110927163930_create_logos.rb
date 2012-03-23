class CreateLogos < ActiveRecord::Migration
  def change
    create_table :logos do |t|
      t.boolean  :active, :default => false
      t.string   :image_file_name
      t.string   :image_content_type
      t.integer  :image_file_size
      t.datetime :image_updated_at

      t.timestamps
    end
  end
end
