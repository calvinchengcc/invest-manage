class CreateStocks < ActiveRecord::Migration
  def change
    create_table :stocks do |t|
      t.string :symbol, null: false
      t.string :exchange, null: false
      t.string :name, null: false

      t.timestamps null: false
    end

    add_index :stocks, [:symbol, :exchange], unique: true
  end
end
