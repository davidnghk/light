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

ActiveRecord::Schema.define(version: 20160511022543) do

  create_table "stock_prices", force: :cascade do |t|
    t.date     "trade_date", null: false
    t.decimal  "open"
    t.integer  "volume"
    t.decimal  "high"
    t.decimal  "low"
    t.decimal  "close",      null: false
    t.decimal  "adj_close"
    t.decimal  "return"
    t.integer  "stock_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "stock_prices", ["stock_id", "trade_date"], name: "index_stock_prices_on_stock_id_and_trade_date", unique: true
  add_index "stock_prices", ["stock_id"], name: "index_stock_prices_on_stock_id"

  create_table "stocks", force: :cascade do |t|
    t.string   "ticker"
    t.string   "name"
    t.decimal  "last_price"
    t.date     "pricing_date"
    t.decimal  "return"
    t.decimal  "risk"
    t.decimal  "sharpe"
    t.decimal  "alpha"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "parent_id"
    t.integer  "no_of_prices"
  end

  add_index "stocks", ["parent_id"], name: "index_stocks_on_parent_id"

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
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
