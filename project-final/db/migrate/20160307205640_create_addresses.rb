class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :number
      t.string :street
      t.string :city, null: false
      t.string :country, null: false
      t.string :postal_code

      t.timestamps null: false
    end
  end
end
