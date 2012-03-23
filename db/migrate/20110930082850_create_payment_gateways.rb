class CreatePaymentGateways < ActiveRecord::Migration
  def change
    create_table :payment_gateways do |t|
      t.string :name
      t.string :login
      t.string :password
      t.string :signature
      t.boolean :status

      t.timestamps
    end
  end
end
