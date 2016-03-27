class CreateHoldings < ActiveRecord::Migration
  def change
    create_table :holdings do |t|
      t.integer :portfolio_id, null: false, index: true
      t.integer :stock_id, null: false, index: true
      t.integer :num_shares, null: false
      t.datetime :purchase_date, null: false
      t.decimal :price, null: false

      t.check 'num_shares > 0', name: 'chk_shares'
      t.check 'price > 0', name: 'chk_holdings'
    end
  end
end
