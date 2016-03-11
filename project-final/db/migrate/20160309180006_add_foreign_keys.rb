class AddForeignKeys < ActiveRecord::Migration
  def change
    add_foreign_key :users, :addresses
    add_foreign_key :portfolios, :users, column: :owner_id
    add_foreign_key :portfolios, :users, column: :manager_id
    add_foreign_key :holdings, :portfolios, on_delete: :restrict
    add_foreign_key :holdings, :stocks, on_delete: :restrict
    add_foreign_key :stocks, :exchanges, on_delete: :restrict
  end
end
