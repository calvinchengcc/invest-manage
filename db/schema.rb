# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160309180006) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", force: :cascade do |t|
    t.string "street_address", null: false
    t.string "city",           null: false
    t.string "country",        null: false
    t.string "postal_code",    null: false
  end

  create_table "exchanges", force: :cascade do |t|
    t.string "code", null: false
    t.string "name", null: false
  end

  add_index "exchanges", ["code"], name: "index_exchanges_on_code", unique: true, using: :btree

  create_table "holdings", force: :cascade do |t|
    t.integer  "portfolio_id",  null: false
    t.integer  "stock_id",      null: false
    t.integer  "num_shares",    null: false
    t.datetime "purchase_date", null: false
    t.decimal  "price",         null: false
  end

  add_index "holdings", ["portfolio_id"], name: "index_holdings_on_portfolio_id", using: :btree
  add_index "holdings", ["stock_id"], name: "index_holdings_on_stock_id", using: :btree

  add_check "holdings", "(num_shares > 0)", name: "chk_shares"
  add_check "holdings", "(price > (0)::numeric)", name: "chk_holdings"

  create_table "portfolios", force: :cascade do |t|
    t.string  "purpose"
    t.date    "creation_date"
    t.decimal "principal",     null: false
    t.decimal "cash",          null: false
    t.integer "owner_id",      null: false
    t.integer "manager_id",    null: false
  end

  add_index "portfolios", ["manager_id"], name: "index_portfolios_on_manager_id", using: :btree
  add_index "portfolios", ["owner_id"], name: "index_portfolios_on_owner_id", using: :btree

  add_check "portfolios", "(principal >= (0)::numeric)", name: "chk_principal"
  add_check "portfolios", "(cash >= (0)::numeric)", name: "chk_cash"

  create_table "stocks", force: :cascade do |t|
    t.string  "symbol",      null: false
    t.integer "exchange_id", null: false
    t.string  "name",        null: false
  end

  add_index "stocks", ["symbol"], name: "index_stocks_on_symbol", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "name",                                null: false
    t.integer  "role",                   default: 0,  null: false
    t.string   "phone",                               null: false
    t.integer  "address_id",                          null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_check "users", "(role = ANY (ARRAY[0, 1, 2]))", name: "chk_role"

  add_foreign_key "holdings", "portfolios", on_delete: :cascade
  add_foreign_key "holdings", "stocks"
  add_foreign_key "portfolios", "users", column: "manager_id"
  add_foreign_key "portfolios", "users", column: "owner_id"
  add_foreign_key "stocks", "exchanges"
  add_foreign_key "users", "addresses"
end
