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

ActiveRecord::Schema.define(version: 20140103162641) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "pg_trgm"

  create_table "comments", force: true do |t|
    t.text     "comment"
    t.integer  "pledger_id"
    t.integer  "show_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "donations", force: true do |t|
    t.integer  "pledger_id"
    t.integer  "slot_id"
    t.decimal  "amount"
    t.string   "payment_method"
    t.boolean  "pledge_form_sent"
    t.boolean  "payment_received"
    t.boolean  "gpo_sent"
    t.boolean  "gpo_processed"
    t.string   "phone_operator"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "donations", ["pledger_id"], name: "index_donations_on_pledger_id", using: :btree
  add_index "donations", ["slot_id"], name: "index_donations_on_slot_id", using: :btree

  create_table "items", force: true do |t|
    t.string   "name"
    t.decimal  "taxable_value"
    t.decimal  "cost"
    t.integer  "stock"
    t.boolean  "backorderable"
    t.string   "shape"
    t.text     "note"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "pledgers", force: true do |t|
    t.boolean  "individual"
    t.string   "email"
    t.string   "affiliation"
    t.string   "local_phone"
    t.string   "local_address"
    t.string   "local_address2"
    t.string   "local_city"
    t.string   "local_state"
    t.string   "local_zip"
    t.string   "perm_phone"
    t.string   "perm_address"
    t.string   "perm_address2"
    t.string   "perm_city"
    t.string   "perm_state"
    t.string   "perm_zip"
    t.string   "perm_country"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "name"
  end

  add_index "pledgers", ["name"], name: "trgm_index", using: :btree

  create_table "rewards", force: true do |t|
    t.integer  "pledger_id"
    t.integer  "item_id"
    t.boolean  "premia_sent"
    t.boolean  "taxed"
    t.text     "comment"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "rewards", ["item_id"], name: "index_rewards_on_item_id", using: :btree
  add_index "rewards", ["pledger_id"], name: "index_rewards_on_pledger_id", using: :btree

  create_table "semesters", force: true do |t|
    t.integer  "year"
    t.integer  "month"
    t.integer  "goal"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "shows", force: true do |t|
    t.string   "name"
    t.string   "dj"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "slots", force: true do |t|
    t.integer  "show_id"
    t.integer  "weekday"
    t.time     "start"
    t.time     "end"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "semester_id"
  end

  add_index "slots", ["semester_id"], name: "index_slots_on_semester_id", using: :btree
  add_index "slots", ["show_id"], name: "index_rewards_on_show_id", using: :btree

  create_table "users", force: true do |t|
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
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "username"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
