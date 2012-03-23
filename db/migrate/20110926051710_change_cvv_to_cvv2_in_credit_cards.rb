class ChangeCvvToCvv2InCreditCards < ActiveRecord::Migration
  def change
    rename_column :credit_cards, :cvv, :cvv2
  end
end
