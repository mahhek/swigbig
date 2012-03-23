class AddColumnQrcodeToBars < ActiveRecord::Migration
  def change
    add_column :bars, :qrcode, :string
  end
end
