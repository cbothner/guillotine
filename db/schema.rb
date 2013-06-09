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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130609175249) do

  create_table "donations", :force => true do |t|
    t.integer  "pledger_id"
    t.integer  "show_id"
    t.decimal  "amount"
    t.string   "payment_method"
    t.boolean  "pledge_form_sent"
    t.boolean  "payment_received"
    t.boolean  "gpo_sent"
    t.boolean  "gpo_processed"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "donations", ["pledger_id"], :name => "index_donations_on_pledger_id"
  add_index "donations", ["show_id"], :name => "index_donations_on_show_id"

  create_table "items", :force => true do |t|
    t.string   "name"
    t.decimal  "taxable_value"
    t.decimal  "cost"
    t.integer  "stock"
    t.boolean  "backorderable"
    t.string   "shape"
    t.text     "note"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "pledgers", :force => true do |t|
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
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.string   "name"
  end

  add_index "pledgers", ["name"], :name => "trgm_index"

  create_table "rewards", :force => true do |t|
    t.integer  "pledger_id"
    t.integer  "item_id"
    t.boolean  "premia_sent"
    t.text     "comment"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "rewards", ["item_id"], :name => "index_rewards_on_item_id"
  add_index "rewards", ["pledger_id"], :name => "index_rewards_on_pledger_id"

  create_table "shows", :force => true do |t|
    t.integer  "semester"
    t.integer  "weekday"
    t.time     "start"
    t.time     "end"
    t.string   "name"
    t.string   "dj"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
