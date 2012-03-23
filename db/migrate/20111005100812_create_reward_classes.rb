class CreateRewardClasses < ActiveRecord::Migration
  def change
    create_table :reward_classes do |t|
      t.string :name

      t.timestamps
    end
  end
end
