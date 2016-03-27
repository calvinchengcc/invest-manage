class CreatePortfolios < ActiveRecord::Migration
  def change
    create_table :portfolios do |t|
      t.string  :purpose
      t.date :creation_date
      t.decimal :principal, null: false, default: 0
      t.decimal :cash, null: false, default: 0
      t.integer :owner_id, null: false, index: true
      t.integer :manager_id, null: false, index: true

      t.check 'principal >= 0', name: 'chk_principal'
      t.check 'cash >= 0', name: 'chk_cash'
    end
  end
end
