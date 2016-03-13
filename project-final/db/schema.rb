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

  add_index "exchanges", ["code"], name: "index_exchanges_on_code", unique: true

  create_table "holdings", force: :cascade do |t|
    t.integer  "portfolio_id", null: false
    t.integer  "stock_id",     null: false
    t.integer  "num_shares",   null: false
    t.datetime "datetime",     null: false
    t.decimal  "price",        null: false
  end

  add_index "holdings", ["portfolio_id"], name: "index_holdings_on_portfolio_id"
  add_index "holdings", ["stock_id"], name: "index_holdings_on_stock_id"

  create_table "portfolios", force: :cascade do |t|
    t.string  "purpose"
    t.date    "creation_date"
    t.decimal "principal",     default: 0.0, null: false
    t.decimal "cash",          default: 0.0, null: false
    t.integer "owner_id",                    null: false
    t.integer "manager_id",                  null: false
  end

  add_index "portfolios", ["manager_id"], name: "index_portfolios_on_manager_id"
  add_index "portfolios", ["owner_id"], name: "index_portfolios_on_owner_id"

  create_table "stocks", force: :cascade do |t|
    t.string  "symbol",      null: false
    t.integer "exchange_id", null: false
    t.string  "name",        null: false
  end

  add_index "stocks", ["symbol"], name: "index_stocks_on_symbol", unique: true

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
    t.string   "phone"
    t.integer  "address_id"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
