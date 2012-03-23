class DeviseCreateBars < ActiveRecord::Migration
  def self.up
    create_table(:bars) do |t|
      t.database_authenticatable :null => false
      t.recoverable
      t.rememberable
      t.trackable
      t.confirmable
      t.token_authenticatable

      t.timestamps
    end

    add_index :bars, :email,                :unique => true
    add_index :bars, :reset_password_token, :unique => true
    add_index :bars, :confirmation_token,   :unique => true
    add_index :bars, :authentication_token, :unique => true
  end

  def self.down
    drop_table :bars
  end
end
