class CreateStocks < ActiveRecord::Migration
  def change
    create_table :stocks do |t|
      t.string :symbol, null: false
      t.integer :exchange_id, null: false
      t.string :name, null: false

      t.index :symbol, unique: true
    end
  end
end
