class CreateCoupons < ActiveRecord::Migration
  def change
    create_table :coupons do |t|
      t.string :code
      t.date :expire_date

      t.timestamps
    end
  end
end
