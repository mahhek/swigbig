class CreateBarsCreditCards < ActiveRecord::Migration
  def self.up
    create_table :credit_cards do |t|
      t.integer :bar_id
      t.string :first_name
      t.string :last_name
      t.string :number
      t.integer :month
      t.integer :year
      t.integer :cvv

      t.timestamps
    end
  end

  def self.down
    drop_table :credit_cards
  end
end
