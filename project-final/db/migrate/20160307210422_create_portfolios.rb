class CreatePortfolios < ActiveRecord::Migration
  def change
    create_table :portfolios do |t|
      t.string  :purpose
      t.date :creation_date
      t.decimal :principal, null: false, default: 0
      t.decimal :cash, null: false, default: 0
      t.integer :owner_id, null: false
      t.integer :manager_id, null: false
      t.timestamps null: false
    end
    add_foreign_key :portfolios, :users, column: :owner_id
    add_foreign_key :portfolios, :users, column: :manager_id
  end
end
