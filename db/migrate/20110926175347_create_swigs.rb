class CreateSwigs < ActiveRecord::Migration
  def change
    create_table :swigs do |t|
      t.integer :user_id
      t.integer :bar_id

      t.timestamps
    end

    add_index :swigs, :user_id
    add_index :swigs, :bar_id
  end
end
