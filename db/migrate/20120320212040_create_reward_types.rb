class CreateRewardTypes < ActiveRecord::Migration
  def change
    create_table :reward_types do |t|
      t.string :name

      t.timestamps
    end
  end
end
