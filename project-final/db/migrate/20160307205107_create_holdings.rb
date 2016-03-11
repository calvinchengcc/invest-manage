class CreateHoldings < ActiveRecord::Migration
  def change
    create_table :holdings do |t|
      t.integer :portfolio_id, null: false, index: true
      t.integer :stock_id, null: false, index: true
      t.integer :num_shares, null: false
      t.datetime :datetime, null: false
      t.decimal :price, null: false
    end
  end
end
