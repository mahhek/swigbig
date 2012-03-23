class CreateSlogans < ActiveRecord::Migration
  def change
    create_table :slogans do |t|
      t.string :title
      t.boolean :active, :default => false

      t.timestamps
    end
  end
end
