# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130108142210) do

  create_table "accounts", :force => true do |t|
    t.string   "name"
    t.integer  "currency_id"
    t.float    "initial"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "budgets", :force => true do |t|
    t.float    "amount"
    t.integer  "user_id"
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.integer  "parent_category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "currencies", :force => true do |t|
    t.string   "name"
    t.float    "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "feemoves", :force => true do |t|
    t.integer  "fee_id"
    t.integer  "move_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "fees", :force => true do |t|
    t.integer  "user_id"
    t.integer  "account_id"
    t.string   "description"
    t.float    "amount"
    t.integer  "operation"
    t.integer  "category_id"
    t.integer  "fee_cant"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "moves", :force => true do |t|
    t.string   "description"
    t.integer  "account_id"
    t.integer  "user_id"
    t.float    "amount"
    t.integer  "operation"
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "previsions", :force => true do |t|
    t.string   "description"
    t.integer  "account_id"
    t.integer  "user_id"
    t.float    "amount"
    t.integer  "operation"
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sched_previsions", :force => true do |t|
    t.string   "description"
    t.integer  "account_id"
    t.integer  "user_id"
    t.float    "amount"
    t.integer  "operation"
    t.integer  "category_id"
    t.integer  "last_apply_month"
    t.integer  "apply_day"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "email"
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.integer  "currency_id"
  end

end
