class CreateExchanges < ActiveRecord::Migration
  def change
    create_table :exchanges do |t|
      t.string :code, null: false
      t.string :name, null: false

      t.index :code, unique: true
    end
  end
end
