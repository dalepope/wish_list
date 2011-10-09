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

ActiveRecord::Schema.define(:version => 20111006001126) do

  create_table "draw_exclusions", :force => true do |t|
    t.integer  "excluder_id"
    t.integer  "excluded_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "draw_exclusions", ["excluded_id"], :name => "index_draw_exclusions_on_excluded_id"
  add_index "draw_exclusions", ["excluder_id", "excluded_id"], :name => "index_draw_exclusions_on_excluder_id_and_excluded_id", :unique => true
  add_index "draw_exclusions", ["excluder_id"], :name => "index_draw_exclusions_on_excluder_id"

  create_table "drawn_names", :force => true do |t|
    t.integer  "giver_id"
    t.integer  "receiver_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "drawn_names", ["giver_id"], :name => "index_drawn_names_on_giver_id", :unique => true
  add_index "drawn_names", ["receiver_id"], :name => "index_drawn_names_on_receiver_id", :unique => true

  create_table "ownerships", :force => true do |t|
    t.integer  "owner_id"
    t.integer  "owned_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ownerships", ["owned_id"], :name => "index_ownerships_on_owned_id"
  add_index "ownerships", ["owner_id", "owned_id"], :name => "index_ownerships_on_owner_id_and_owned_id", :unique => true
  add_index "ownerships", ["owner_id"], :name => "index_ownerships_on_owner_id"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "encrypted_password"
    t.string   "salt"
    t.boolean  "admin",              :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "in_draw",            :default => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

  create_table "wish_categories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "wish_categories", ["name"], :name => "index_wish_categories_on_name", :unique => true

  create_table "wish_items", :force => true do |t|
    t.text     "description"
    t.string   "url"
    t.integer  "category_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "wish_items", ["user_id"], :name => "index_wish_items_on_user_id"

end
