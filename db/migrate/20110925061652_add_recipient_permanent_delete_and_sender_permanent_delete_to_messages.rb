class AddRecipientPermanentDeleteAndSenderPermanentDeleteToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :recipient_permanent_delete, :boolean, :default => false
    add_column :messages, :sender_permanent_delete, :boolean, :default => false
  end
end
