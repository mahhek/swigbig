class CreateStatus < ActiveRecord::Migration
  def change
    create_table :status do |t|
      t.integer :user_id
      t.string :body

      t.timestamps
    end

    add_index :status, :user_id
  end
end
