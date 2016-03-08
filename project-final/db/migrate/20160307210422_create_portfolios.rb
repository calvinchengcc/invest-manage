class CreatePortfolios < ActiveRecord::Migration
  def change
    create_table :portfolios do |t|
      t.string  :purpose
      t.date :creation_date
      t.decimal :principal, null: false, default: 0
      t.decimal :cash, null: false, default: 0
      t.integer :owner_id, null: false, index: true
      t.integer :manager_id, null: false, index: true

      t.timestamps null: false
    end
  end
end
