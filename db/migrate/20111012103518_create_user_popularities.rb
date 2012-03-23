class CreateUserPopularities < ActiveRecord::Migration
  def change
    create_table :user_popularities do |t|
      t.integer :user_id
      t.integer :bar_id
      t.integer :total_invited, :default => 0
      t.integer :total_attendee, :default => 0

      t.timestamps
    end
    add_index :user_popularities, [:user_id, :bar_id]
  end
end
