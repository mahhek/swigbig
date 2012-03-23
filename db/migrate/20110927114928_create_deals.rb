class CreateDeals < ActiveRecord::Migration
  def change
    create_table :deals do |t|
      t.string :name
      t.integer :tier
      t.integer :tipping_points
      t.integer :day_of_week

      t.timestamps
    end
  end
end
