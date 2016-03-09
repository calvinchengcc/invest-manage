class CreateStockExchanges < ActiveRecord::Migration
  def change
    create_table :stock_exchanges do |t|
      t.string :exchange_code, null: false
      t.string :exchange_name, null: false

      t.index :exchange_code, unique: true
    end
  end
end
