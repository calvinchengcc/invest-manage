class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :street_address, null: false
      t.string :city, null: false
      t.string :country, null: false
      t.string :postal_code, null: false
    end
  end
end
