class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :title
      t.string :subject
      t.text :content

      t.timestamps
    end
  end
end
