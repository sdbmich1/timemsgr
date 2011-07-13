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

ActiveRecord::Schema.define(:version => 20110704080644) do

  create_table "affiliation_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "affiliations", :force => true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "affiliation_type"
  end

  add_index "affiliations", ["user_id", "name"], :name => "index_affiliations_on_user_id_and_name", :unique => true
  add_index "affiliations", ["user_id"], :name => "index_affiliations_on_user_id"

  create_table "associates", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "associates", ["user_id"], :name => "index_associates_on_user_id"

  create_table "authentications", :force => true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "calendar_events", :force => true do |t|
    t.integer  "calendar_id"
    t.integer  "event_id"
    t.date     "start_date"
    t.date     "end_date"
    t.date     "original_start_date"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "calendar_events", ["calendar_id", "event_id"], :name => "index_calendar_events_on_calendar_id_and_event_id", :unique => true

  create_table "calendars", :force => true do |t|
    t.string   "name"
    t.string   "type"
    t.string   "title"
    t.string   "template"
    t.integer  "template_id"
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "location_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "calendars", ["location_id"], :name => "index_calendars_on_location_id"

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
    t.string   "hide"
    t.string   "status"
    t.integer  "sortkey"
  end

  create_table "channel_interests", :force => true do |t|
    t.integer  "channel_id"
    t.integer  "interest_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "channel_interests", ["channel_id", "interest_id"], :name => "index_channel_interests_on_channel_id_and_interest_id", :unique => true

  create_table "channel_locations", :force => true do |t|
    t.integer  "location_id"
    t.integer  "channel_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "channel_locations", ["channel_id"], :name => "index_channel_locations_on_channel_id"
  add_index "channel_locations", ["location_id"], :name => "index_channel_locations_on_location_id"

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
    t.string   "hide"
    t.string   "status"
    t.integer  "sortkey"
    t.string   "code"
  end

  add_index "channels", ["location_id"], :name => "index_channels_on_location_id"

  create_table "cities", :force => true do |t|
    t.string   "city"
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "event_page_sections", :force => true do |t|
    t.string   "event_type"
    t.string   "title"
    t.integer  "rank"
    t.string   "visible"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "event_page_sections", ["event_type"], :name => "event_type_idx", :unique => true

  create_table "event_photos", :force => true do |t|
    t.integer  "event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.integer  "user_id"
  end

  create_table "event_types", :force => true do |t|
    t.string   "Description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "Code"
  end

  create_table "events", :force => true do |t|
    t.string   "event_name"
    t.string   "title"
    t.string   "description"
    t.date     "start_date"
    t.date     "end_date"
    t.time     "start_time"
    t.time     "end_time"
    t.string   "event_type"
    t.string   "frequency"
    t.string   "location"
    t.integer  "start_time_zone_id"
    t.integer  "end_time_zone_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status"
    t.string   "hide"
    t.string   "cversion"
    t.date     "post_date"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.string   "start_time_zone",    :default => "UTC"
    t.string   "end_time_zone",      :default => "UTC"
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.integer  "postalcode"
    t.string   "other_details"
    t.string   "overview"
    t.string   "country"
    t.integer  "user_id"
    t.string   "contact_name"
    t.string   "website"
    t.string   "email"
    t.string   "phone"
    t.float    "longitude"
    t.float    "latitude"
    t.boolean  "gmaps"
    t.boolean  "family_flg"
    t.boolean  "friends_flg"
    t.boolean  "world_flg"
    t.string   "activity_type"
    t.integer  "reminder"
    t.string   "remind_method"
    t.integer  "credits"
  end

  add_index "events", ["cversion"], :name => "index_events_on_cversion"
  add_index "events", ["end_date"], :name => "index_events_on_end_date"
  add_index "events", ["start_date"], :name => "index_events_on_start_date"
  add_index "events", ["user_id"], :name => "index_events_on_user_id"

  create_table "frequencies", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "host_profiles", :force => true do |t|
    t.integer  "user_id"
    t.string   "address1"
    t.string   "address2"
    t.string   "city"
    t.string   "state"
    t.integer  "postalcode"
    t.string   "home_phone"
    t.string   "work_phone"
    t.string   "cell_phone"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "country"
    t.string   "company"
    t.string   "title"
    t.string   "hide"
    t.string   "status"
    t.string   "ethnicity"
    t.string   "nationality"
    t.string   "industry"
  end

  add_index "host_profiles", ["user_id"], :name => "index_host_profiles_on_user_id"

  create_table "interests", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "category_id"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.integer  "sortkey"
    t.string   "status"
    t.string   "hide"
  end

  create_table "interests_users", :id => false, :force => true do |t|
    t.integer "user_id",     :null => false
    t.integer "interest_id", :null => false
  end

  add_index "interests_users", ["user_id", "interest_id"], :name => "int_user_index", :unique => true

  create_table "lifeeventtype", :primary_key => "ID", :force => true do |t|
    t.string   "Code"
    t.string   "Description"
    t.string   "status"
    t.float    "sortkey"
    t.string   "hide"
    t.datetime "CreateDateTime"
    t.datetime "LastModifyDateTime"
    t.string   "LastModifyBy"
  end

  add_index "lifeeventtype", ["Code"], :name => "code_idx"

  create_table "locations", :force => true do |t|
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.string   "time_zone"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "organizations", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "org_type"
  end

  add_index "organizations", ["name"], :name => "index_organizations_on_name"

  create_table "reward_credits", :force => true do |t|
    t.string   "name"
    t.string   "model_name"
    t.integer  "credits"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "session_prefs", :force => true do |t|
    t.string   "name"
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

  create_table "settings", :force => true do |t|
    t.integer  "user_id"
    t.integer  "session_pref_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "settings", ["session_pref_id"], :name => "index_settings_on_session_pref_id"
  add_index "settings", ["user_id"], :name => "index_settings_on_user_id"

  create_table "statecode", :id => false, :force => true do |t|
    t.float  "ID"
    t.string "StateAbbr"
    t.string "State"
    t.float  "SortKey"
    t.string "hide"
    t.string "status"
    t.string "CreateDateTime"
    t.string "LastModifyDateTime"
    t.string "LastModifyBy"
  end

  create_table "stdjurisdictionchannelnames", :id => false, :force => true do |t|
    t.float    "ID"
    t.string   "code"
    t.string   "description"
    t.string   "description2"
    t.string   "interest1"
    t.string   "interest2"
    t.string   "interest3"
    t.string   "interest4"
    t.string   "interest5"
    t.string   "status"
    t.float    "sortkey"
    t.string   "hide"
    t.datetime "CreateDateTime"
    t.datetime "LastModifyDateTime"
    t.string   "LastModifyBy"
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

  create_table "tempinterests", :id => false, :force => true do |t|
    t.string "Category"
    t.string "Interest"
    t.float  "Sortkey"
  end

  create_table "time_ranges", :force => true do |t|
    t.string   "description"
    t.string   "hide"
    t.integer  "numdays"
    t.integer  "sortkey"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_credits", :force => true do |t|
    t.integer  "user_id"
    t.integer  "event_id"
    t.string   "context"
    t.integer  "credits"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_credits", ["user_id"], :name => "index_user_credits_on_user_id"

  create_table "user_events", :force => true do |t|
    t.integer  "user_id"
    t.integer  "event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_events", ["event_id"], :name => "index_user_events_on_event_id"
  add_index "user_events", ["user_id", "event_id"], :name => "index_user_events_on_user_id_and_event_id", :unique => true
  add_index "user_events", ["user_id"], :name => "index_user_events_on_user_id"

  create_table "user_photos", :force => true do |t|
    t.integer  "user_id"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
  end

  add_index "user_photos", ["user_id"], :name => "index_user_photos_on_user_id"

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
    t.integer  "location_id"
    t.string   "username"
    t.string   "time_zone"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["location_id"], :name => "index_users_on_location_id"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["username"], :name => "index_users_on_username"

end
