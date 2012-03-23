class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.text :description
      t.boolean :is_notified, :default => false
      t.integer :notifier_id
      t.references :notifiable, :polymorphic => true
      t.timestamps
    end
    add_index :notifications, [:notifier_id, :notifiable_id]
  end
end
