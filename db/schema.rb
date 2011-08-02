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

ActiveRecord::Schema.define(:version => 20110802000357) do

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

  create_table "event_type_images", :force => true do |t|
    t.string   "event_type"
    t.string   "image_file"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "event_type_images", ["event_type"], :name => "etype_idx", :unique => true

  create_table "event_types", :force => true do |t|
    t.string   "Description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "Code"
    t.string   "photo_file_name"
  end

  add_index "event_types", ["Code"], :name => "index_event_types_on_Code"

  create_table "events", :force => true do |t|
    t.string   "event_name"
    t.string   "event_title"
    t.string   "cbody"
    t.date     "eventstartdate"
    t.date     "eventenddate"
    t.time     "eventstarttime"
    t.time     "eventendtime"
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
    t.string   "mapstreet"
    t.string   "mapcity"
    t.string   "mapstate"
    t.integer  "mapzip"
    t.string   "other_details"
    t.string   "bbody"
    t.string   "mapcountry"
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
    t.string   "mapplacename"
  end

  add_index "events", ["cversion"], :name => "index_events_on_cversion"
  add_index "events", ["event_type"], :name => "index_events_on_code"
  add_index "events", ["eventenddate"], :name => "index_events_on_end_date"
  add_index "events", ["eventstartdate"], :name => "index_events_on_start_date"
  add_index "events", ["user_id"], :name => "index_events_on_user_id"

  create_table "eventsobs", :primary_key => "ID", :force => true do |t|
    t.string   "eventid",               :limit => 20
    t.string   "event_name",            :limit => 200
    t.string   "event_title",           :limit => 200
    t.string   "event_type",            :limit => 20
    t.integer  "eventday",              :limit => 1
    t.integer  "eventmonth",            :limit => 1
    t.string   "obscaltype",            :limit => 20
    t.string   "annualsamedate",        :limit => 5
    t.integer  "eventgday",             :limit => 1
    t.integer  "eventgmonth",           :limit => 1
    t.datetime "eventstartdate"
    t.datetime "eventenddate"
    t.datetime "eventstarttime"
    t.datetime "eventendtime"
    t.string   "location"
    t.datetime "postdate"
    t.string   "cformat",               :limit => 10
    t.string   "speaker",               :limit => 100
    t.string   "speakertopic"
    t.string   "host",                  :limit => 100
    t.text     "cbody"
    t.text     "bbody"
    t.string   "rsvp",                  :limit => 50
    t.string   "RSVPemail",             :limit => 50
    t.string   "imageID",               :limit => 50
    t.string   "imagetitle",            :limit => 50
    t.string   "imagecaption",          :limit => 100
    t.string   "pdfFilename",           :limit => 50
    t.string   "imagelink",             :limit => 50
    t.string   "notice1send",           :limit => 5
    t.string   "notice2send",           :limit => 5
    t.datetime "expirationdate"
    t.string   "targetoflink",          :limit => 5
    t.string   "linked",                :limit => 5
    t.string   "linkeditemID",          :limit => 20
    t.datetime "origlinkdatetime"
    t.datetime "lastlinkdatetime"
    t.string   "memberonly",            :limit => 5
    t.string   "hide",                  :limit => 5
    t.string   "status",                :limit => 10
    t.datetime "CreateDateTime"
    t.datetime "LastModifyDateTime"
    t.string   "LastModifyBy",          :limit => 50
    t.string   "pageexttype",           :limit => 20
    t.string   "pageextsrc",            :limit => 5
    t.string   "pageextsourceID",       :limit => 50
    t.string   "pageextID",             :limit => 20
    t.string   "image2ID",              :limit => 50
    t.string   "image2title",           :limit => 50
    t.string   "image2caption",         :limit => 100
    t.string   "image2link",            :limit => 50
    t.string   "sponsorlink",           :limit => 100
    t.string   "mapstreet",             :limit => 40
    t.string   "mapcity",               :limit => 40
    t.string   "mapstate",              :limit => 25
    t.string   "mapzip",                :limit => 10
    t.string   "mapcountry",            :limit => 40
    t.string   "mapplacename",          :limit => 60
    t.integer  "reliability",           :limit => 1
    t.float    "localGMToffset"
    t.float    "endGMToffset"
    t.string   "resvtargetID",          :limit => 50
    t.string   "allowPrivCircle",       :limit => 5
    t.string   "allowSocCircle",        :limit => 5
    t.string   "allowWorldCircle",      :limit => 5
    t.string   "ShowPrivCircle",        :limit => 5
    t.string   "ShowSocCircle",         :limit => 5
    t.string   "ShowWorldCircle",       :limit => 50
    t.string   "contentsourceID",       :limit => 50
    t.string   "contentsourceURL",      :limit => 50
    t.string   "allowsubscription",     :limit => 5
    t.string   "subscriberentry",       :limit => 5
    t.string   "subscriptionsourceID",  :limit => 50
    t.string   "subscriptionsourceURL", :limit => 100
  end

  create_table "eventspriv", :primary_key => "ID", :force => true do |t|
    t.string   "eventid",               :limit => 20
    t.string   "event_name",            :limit => 200
    t.string   "event_title",           :limit => 200
    t.string   "event_type",            :limit => 20
    t.datetime "eventstartdate"
    t.datetime "eventenddate"
    t.datetime "eventstarttime"
    t.datetime "eventendtime"
    t.datetime "remindstartdate"
    t.datetime "remindenddate"
    t.datetime "remindtstarttime"
    t.datetime "remindendtime"
    t.string   "reoccurrencetype",      :limit => 20
    t.integer  "reoccurrenceparm1",     :limit => 2
    t.integer  "reoccurrenceparm2",     :limit => 2
    t.string   "location"
    t.datetime "postdate"
    t.string   "cformat",               :limit => 10
    t.string   "speaker",               :limit => 100
    t.string   "speakertopic"
    t.string   "host",                  :limit => 100
    t.text     "cbody"
    t.text     "bbody"
    t.string   "agendaID",              :limit => 50
    t.string   "minutesID",             :limit => 50
    t.string   "rsvp",                  :limit => 5
    t.string   "RSVPemail",             :limit => 50
    t.string   "imageID",               :limit => 50
    t.string   "imagetitle",            :limit => 50
    t.string   "imagecaption",          :limit => 100
    t.string   "pdfFilename",           :limit => 50
    t.string   "imagelink",             :limit => 50
    t.string   "fundraiser",            :limit => 50
    t.string   "notice1send",           :limit => 5
    t.string   "notice2send",           :limit => 5
    t.datetime "expirationdate"
    t.string   "allowsubscription",     :limit => 5
    t.string   "allowPrivCircle",       :limit => 5
    t.string   "allowSocCircle",        :limit => 5
    t.string   "allowWorldCircle",      :limit => 5
    t.string   "targetoflink",          :limit => 5
    t.string   "linked",                :limit => 5
    t.string   "linkeditemID",          :limit => 20
    t.string   "linkedsourceID",        :limit => 50
    t.datetime "origlinkdatetime"
    t.datetime "lastlinkdatetime"
    t.string   "memberonly",            :limit => 5
    t.string   "hide",                  :limit => 5
    t.string   "status",                :limit => 10
    t.datetime "CreateDateTime"
    t.datetime "LastModifyDateTime"
    t.string   "LastModifyBy",          :limit => 50
    t.string   "pageexttype",           :limit => 20
    t.string   "pageextsrc",            :limit => 5
    t.string   "pageextsourceID",       :limit => 50
    t.string   "pageextID",             :limit => 20
    t.string   "image2ID",              :limit => 50
    t.string   "image2title",           :limit => 50
    t.string   "image2caption",         :limit => 100
    t.string   "image2link",            :limit => 50
    t.string   "sponsorlink",           :limit => 100
    t.string   "mapstreet",             :limit => 40
    t.string   "mapcity",               :limit => 40
    t.string   "mapstate",              :limit => 25
    t.string   "mapzip",                :limit => 10
    t.string   "mapcountry",            :limit => 40
    t.string   "mapplacename",          :limit => 60
    t.integer  "reliability"
    t.float    "localGMToffset"
    t.float    "endGMToffset"
    t.string   "resvtargetID",          :limit => 50
    t.string   "subscriberentry",       :limit => 5
    t.string   "contentsourceID",       :limit => 50
    t.string   "contentsourceURL",      :limit => 50
    t.string   "subscriptionsourceID",  :limit => 50
    t.string   "subscriptionsourceURL", :limit => 100
  end

  create_table "eventtypetsd", :id => false, :force => true do |t|
    t.float    "ID"
    t.string   "Code"
    t.string   "Description"
    t.string   "status"
    t.float    "sortkey"
    t.string   "hide"
    t.datetime "CreateDateTime"
    t.datetime "LastModifyDateTime"
    t.string   "LastModifyBy"
  end

  create_table "frequencies", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "gmttimezones", :force => true do |t|
    t.float    "code"
    t.float    "code2"
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
    t.float    "localGMToffset"
  end

  create_table "organizations", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "org_type"
  end

  add_index "organizations", ["name"], :name => "index_organizations_on_name"

  create_table "promos", :force => true do |t|
    t.string   "speaker"
    t.string   "bbody"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "reward_credits", :force => true do |t|
    t.string   "name"
    t.string   "model_name"
    t.integer  "credits"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "reward_msgs", :force => true do |t|
    t.string   "msg_type"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "reward_msgs", ["msg_type"], :name => "index_reward_msgs_on_msg_type"

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

  create_table "user_events", :primary_key => "ID", :force => true do |t|
    t.string   "eventid"
    t.string   "event_name"
    t.string   "event_type"
    t.datetime "eventstartdate"
    t.datetime "eventenddate"
    t.datetime "eventstarttime"
    t.datetime "eventendtime"
    t.string   "localGMToffset"
    t.string   "endGMToffset"
    t.string   "location"
    t.datetime "postdate"
    t.string   "cformat"
    t.string   "event_title"
    t.string   "speaker"
    t.string   "speakertopic"
    t.string   "host"
    t.text     "cbody",                 :limit => 16777215
    t.text     "bbody",                 :limit => 16777215
    t.string   "agendaID"
    t.string   "minutesID"
    t.string   "MembershipType"
    t.string   "Committee"
    t.string   "rsvp"
    t.string   "RSVPemail"
    t.string   "imageID"
    t.string   "imagetitle"
    t.string   "imagecaption"
    t.string   "pdfFilename"
    t.string   "imagelink"
    t.string   "fundraiser"
    t.string   "progserv"
    t.string   "prodserv"
    t.string   "profserv"
    t.string   "listID"
    t.string   "coordinatorID"
    t.string   "notice1send"
    t.string   "notice2send"
    t.string   "expirationdate"
    t.float    "MemberFee"
    t.float    "NonMemberFee"
    t.float    "SpouseFee"
    t.string   "GroupFee"
    t.string   "AffiliateFee"
    t.string   "AtDoorFee"
    t.string   "LateFeeDate"
    t.string   "LateMemberFee"
    t.string   "LateSpouseFee"
    t.string   "LateNonMemberFee"
    t.string   "LateGroupFee"
    t.string   "LateAffiliateFee"
    t.string   "Other1Title"
    t.float    "Other1Fee"
    t.string   "Other2Title"
    t.float    "Other2Fee"
    t.string   "Other3Title"
    t.float    "Other3Fee"
    t.string   "Other4Title"
    t.float    "Other4Fee"
    t.string   "Other5Title"
    t.float    "Other5Fee"
    t.string   "Other6Title"
    t.float    "Other6Fee"
    t.string   "GalleryID"
    t.string   "allowsubscription"
    t.string   "subscriberentry"
    t.string   "contentsourceID"
    t.string   "contentsourceURL"
    t.string   "subscriptionsourceID"
    t.string   "subscriptionsourceURL"
    t.string   "targetoflink"
    t.string   "linked"
    t.string   "linkeditemID"
    t.string   "origlinkdatetime"
    t.datetime "lastlinkdatetime"
    t.string   "memberonly"
    t.string   "hide"
    t.string   "status"
    t.datetime "CreateDateTime"
    t.datetime "LastModifyDateTime"
    t.string   "LastModifyBy"
    t.string   "pageexttype"
    t.string   "pageextsrc"
    t.string   "pageextsourceID"
    t.string   "pageextID"
    t.string   "image2ID"
    t.string   "image2title"
    t.string   "image2caption"
    t.string   "image2link"
    t.string   "sponsorlink"
    t.string   "mapstreet"
    t.string   "mapcity"
    t.string   "mapstate"
    t.string   "mapzip"
    t.string   "mapcountry"
    t.string   "mapplacename"
    t.float    "reliability"
    t.string   "resvtargetID"
  end

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
    t.float    "localGMToffset"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["location_id"], :name => "index_users_on_location_id"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["username"], :name => "index_users_on_username"

  create_table "wsevents", :primary_key => "ID", :force => true do |t|
    t.string   "eventid"
    t.string   "event_name"
    t.string   "event_type"
    t.date     "eventstartdate"
    t.date     "eventenddate"
    t.time     "eventstarttime"
    t.time     "eventendtime"
    t.string   "localGMToffset"
    t.string   "endGMToffset"
    t.string   "location"
    t.datetime "postdate"
    t.string   "cformat"
    t.string   "event_title"
    t.string   "speaker"
    t.string   "speakertopic"
    t.string   "host"
    t.text     "cbody",                 :limit => 16777215
    t.text     "bbody",                 :limit => 16777215
    t.string   "agendaID"
    t.string   "minutesID"
    t.string   "MembershipType"
    t.string   "Committee"
    t.string   "rsvp"
    t.string   "RSVPemail"
    t.string   "imageID"
    t.string   "imagetitle"
    t.string   "imagecaption"
    t.string   "pdfFilename"
    t.string   "imagelink"
    t.string   "fundraiser"
    t.string   "progserv"
    t.string   "prodserv"
    t.string   "profserv"
    t.string   "listID"
    t.string   "coordinatorID"
    t.string   "notice1send"
    t.string   "notice2send"
    t.string   "expirationdate"
    t.float    "MemberFee"
    t.float    "NonMemberFee"
    t.float    "SpouseFee"
    t.string   "GroupFee"
    t.string   "AffiliateFee"
    t.string   "AtDoorFee"
    t.string   "LateFeeDate"
    t.string   "LateMemberFee"
    t.string   "LateSpouseFee"
    t.string   "LateNonMemberFee"
    t.string   "LateGroupFee"
    t.string   "LateAffiliateFee"
    t.string   "Other1Title"
    t.float    "Other1Fee"
    t.string   "Other2Title"
    t.float    "Other2Fee"
    t.string   "Other3Title"
    t.float    "Other3Fee"
    t.string   "Other4Title"
    t.float    "Other4Fee"
    t.string   "Other5Title"
    t.float    "Other5Fee"
    t.string   "Other6Title"
    t.float    "Other6Fee"
    t.string   "GalleryID"
    t.string   "allowsubscription"
    t.string   "subscriberentry"
    t.string   "contentsourceID"
    t.string   "contentsourceURL"
    t.string   "subscriptionsourceID"
    t.string   "subscriptionsourceURL"
    t.string   "targetoflink"
    t.string   "linked"
    t.string   "linkeditemID"
    t.string   "origlinkdatetime"
    t.datetime "lastlinkdatetime"
    t.string   "memberonly"
    t.string   "hide"
    t.string   "status"
    t.datetime "CreateDateTime"
    t.datetime "LastModifyDateTime"
    t.string   "LastModifyBy"
    t.string   "pageexttype"
    t.string   "pageextsrc"
    t.string   "pageextsourceID"
    t.string   "pageextID"
    t.string   "image2ID"
    t.string   "image2title"
    t.string   "image2caption"
    t.string   "image2link"
    t.string   "sponsorlink"
    t.string   "mapstreet"
    t.string   "mapcity"
    t.string   "mapstate"
    t.string   "mapzip"
    t.string   "mapcountry"
    t.string   "mapplacename"
    t.float    "reliability"
    t.string   "resvtargetID"
  end

  add_index "wsevents", ["eventstartdate", "eventenddate"], :name => "edate_idx"

end
