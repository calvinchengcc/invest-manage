class CreateHoldings < ActiveRecord::Migration
  def change
    create_table :holdings do |t|
      t.integer :portfolio_id, null: false
      t.integer :stock_id, null: false
      t.integer :num_shares, null: false
      t.datetime :datetime, null: false
      t.decimal :price, null: false

      t.timestamps null: false
    end
    add_foreign_key :holdings, :portfolios, on_delete: :restrict
    add_foreign_key :holdings, :stocks
  end
end
