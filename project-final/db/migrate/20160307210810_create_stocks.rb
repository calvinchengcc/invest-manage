class CreateStocks < ActiveRecord::Migration
  def change
    create_table :stocks do |t|
      t.string :symbol, null: false
      t.string :exchange_id, null: false
      t.string :name, null: false

      t.index :symbol, unique: true

      t.timestamps null: false
    end
  end
end
