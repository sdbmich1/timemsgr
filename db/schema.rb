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

ActiveRecord::Schema.define(:version => 20110410050426) do

  create_table "associates", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "associates", ["user_id"], :name => "index_associates_on_user_id"

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.string   "type"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
  end

  create_table "channel_interests", :force => true do |t|
    t.integer  "channel_id"
    t.integer  "interest_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "channel_interests", ["channel_id", "interest_id"], :name => "index_channel_interests_on_channel_id_and_interest_id", :unique => true

  create_table "channels", :force => true do |t|
    t.string   "name"
    t.string   "title"
    t.string   "channel_type"
    t.string   "channel_class"
    t.integer  "location_id"
    t.integer  "interest_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "start_date"
    t.date     "end_date"
    t.time     "start_time"
    t.time     "end_time"
    t.date     "post_date"
    t.date     "expiration_date"
    t.string   "author"
    t.string   "topic"
    t.integer  "calender_id"
    t.string   "channel_status"
    t.string   "channel_scope"
  end

  add_index "channels", ["location_id"], :name => "index_channels_on_location_id"

  create_table "cities", :force => true do |t|
    t.string   "city"
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", :force => true do |t|
    t.string   "name"
    t.string   "title"
    t.string   "description"
    t.date     "start_date"
    t.date     "end_date"
    t.time     "start_time"
    t.time     "end_time"
    t.string   "type"
    t.string   "frequency"
    t.string   "location"
    t.integer  "start_time_zone_id"
    t.integer  "end_time_zone_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "interest_categories", :id => false, :force => true do |t|
    t.integer  "interest_id"
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "interest_categories", ["interest_id", "category_id"], :name => "index_interest_categories_on_interest_id_and_category_id"

  create_table "interests", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "category_id"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
  end

  create_table "interests_categories_users", :id => false, :force => true do |t|
    t.integer  "user_id"
    t.integer  "interest_id"
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "interests_users", :id => false, :force => true do |t|
    t.integer "user_id",     :null => false
    t.integer "interest_id", :null => false
  end

  add_index "interests_users", ["user_id", "interest_id"], :name => "int_user_index", :unique => true

  create_table "locations", :force => true do |t|
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.string   "time_zone"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subcategories", :force => true do |t|
    t.integer  "category_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subscriptions", :force => true do |t|
    t.integer  "user_id"
    t.integer  "channel_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "subscriptions", ["user_id", "channel_id"], :name => "index_subscriptions_on_user_id_and_channel_id", :unique => true

  create_table "users", :force => true do |t|
    t.string   "email",                               :default => "", :null => false
    t.string   "encrypted_password",   :limit => 128, :default => "", :null => false
    t.string   "password_salt",                       :default => "", :null => false
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "city"
    t.date     "birth_date"
    t.string   "gender"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
