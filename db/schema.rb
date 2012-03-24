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

ActiveRecord::Schema.define(:version => 20120323070510) do

  create_table "activity_stream_preferences", :force => true do |t|
    t.string   "activity"
    t.string   "location"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "activity_stream_preferences", ["activity", "user_id"], :name => "activity_stream_preferences_idx"

  create_table "activity_stream_totals", :force => true do |t|
    t.string   "activity"
    t.integer  "object_id"
    t.string   "object_type"
    t.float    "total",       :default => 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "activity_stream_totals", ["activity"], :name => "index_activity_stream_totals_on_activity"
  add_index "activity_stream_totals", ["object_id", "object_type"], :name => "activity_stream_totals_idx"

  create_table "activity_streams", :force => true do |t|
    t.string   "verb"
    t.string   "activity"
    t.integer  "actor_id"
    t.string   "actor_type"
    t.string   "actor_name_method"
    t.integer  "count",                       :default => 1
    t.integer  "object_id"
    t.string   "object_type"
    t.string   "object_name_method"
    t.integer  "indirect_object_id"
    t.string   "indirect_object_type"
    t.string   "indirect_object_name_method"
    t.string   "indirect_object_phrase"
    t.integer  "status",                      :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "activity_streams", ["actor_id", "actor_type"], :name => "activity_streams_by_actor"
  add_index "activity_streams", ["indirect_object_id", "indirect_object_type"], :name => "activity_streams_by_indirect_object"
  add_index "activity_streams", ["object_id", "object_type"], :name => "activity_streams_by_object"

  create_table "admins", :force => true do |t|
    t.string   "email",                             :default => "", :null => false
    t.string   "encrypted_password", :limit => 128, :default => "", :null => false
    t.integer  "sign_in_count",                     :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "failed_attempts",                   :default => 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admins", ["email"], :name => "index_admins_on_email", :unique => true
  add_index "admins", ["unlock_token"], :name => "index_admins_on_unlock_token", :unique => true

  create_table "bar_deals", :force => true do |t|
    t.integer  "bar_id"
    t.integer  "deal_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_active",       :default => false
    t.boolean  "is_notification", :default => false
    t.integer  "opened_count",    :default => 0
  end

  add_index "bar_deals", ["bar_id", "deal_id"], :name => "index_bar_deals_on_bar_id_and_deal_id"

  create_table "bar_rewards", :force => true do |t|
    t.integer  "bar_id"
    t.integer  "reward_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "bar_rewards", ["bar_id", "reward_id"], :name => "index_bar_rewards_on_bar_id_and_reward_id"

  create_table "bars", :force => true do |t|
    t.string   "email",                                 :default => "",         :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "",         :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "authentication_token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "address"
    t.string   "zip_code"
    t.string   "phone_number"
    t.string   "city"
    t.string   "state_abbr"
    t.string   "country_abbr"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.string   "slug"
    t.boolean  "gmaps"
    t.string   "status",                                :default => "inactive"
    t.string   "qrcode"
    t.integer  "plan_id"
    t.string   "service_uid"
  end

  add_index "bars", ["authentication_token"], :name => "index_bars_on_authentication_token", :unique => true
  add_index "bars", ["confirmation_token"], :name => "index_bars_on_confirmation_token", :unique => true
  add_index "bars", ["email"], :name => "index_bars_on_email", :unique => true
  add_index "bars", ["plan_id"], :name => "index_bars_on_plan_id"
  add_index "bars", ["reset_password_token"], :name => "index_bars_on_reset_password_token", :unique => true
  add_index "bars", ["slug"], :name => "index_bars_on_slug"

  create_table "comments", :force => true do |t|
    t.string   "title",            :limit => 50, :default => ""
    t.text     "comment"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["commentable_id"], :name => "index_comments_on_commentable_id"
  add_index "comments", ["commentable_type"], :name => "index_comments_on_commentable_type"
  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

  create_table "coupons", :force => true do |t|
    t.string   "code"
    t.date     "expire_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "credit_cards", :force => true do |t|
    t.integer  "bar_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "number"
    t.integer  "month"
    t.integer  "year"
    t.integer  "cvv2"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "deal_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "deals", :force => true do |t|
    t.string   "name"
    t.integer  "tier"
    t.integer  "tipping_points"
    t.integer  "day_of_week"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_admin"
    t.integer  "deal_type_id"
  end

  create_table "friendships", :force => true do |t|
    t.integer "user_id"
    t.integer "friend_id"
    t.integer "blocker_id"
    t.boolean "pending",    :default => true
  end

  add_index "friendships", ["user_id", "friend_id"], :name => "index_friendships_on_user_id_and_friend_id", :unique => true

  create_table "logos", :force => true do |t|
    t.boolean  "active",             :default => false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

  create_table "messages", :force => true do |t|
    t.string   "topic"
    t.text     "body"
    t.integer  "received_messageable_id"
    t.string   "received_messageable_type"
    t.integer  "sent_messageable_id"
    t.string   "sent_messageable_type"
    t.boolean  "opened",                     :default => false
    t.boolean  "recipient_delete",           :default => false
    t.boolean  "sender_delete",              :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "ancestry"
    t.boolean  "recipient_permanent_delete", :default => false
    t.boolean  "sender_permanent_delete",    :default => false
  end

  add_index "messages", ["ancestry"], :name => "index_messages_on_ancestry"
  add_index "messages", ["sent_messageable_id", "received_messageable_id"], :name => "acts_as_messageable_ids"

  create_table "notifications", :force => true do |t|
    t.text     "description"
    t.boolean  "is_notified",     :default => false
    t.integer  "notifier_id"
    t.integer  "notifiable_id"
    t.string   "notifiable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "notifier_type"
    t.integer  "bar_id"
  end

  add_index "notifications", ["bar_id"], :name => "index_notifications_on_bar_id"
  add_index "notifications", ["notifier_id", "notifiable_id"], :name => "index_notifications_on_notifier_id_and_notifiable_id"

  create_table "payment_gateways", :force => true do |t|
    t.string   "name"
    t.string   "login"
    t.string   "password"
    t.string   "signature"
    t.boolean  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "plans", :force => true do |t|
    t.string   "name"
    t.float    "price"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "reward_classes", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "reward_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rewards", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "reward_class_id"
    t.text     "description"
    t.boolean  "is_admin"
    t.integer  "reward_point",    :default => 0
    t.boolean  "is_active"
  end

  add_index "rewards", ["reward_class_id"], :name => "index_rewards_on_reward_class_id"

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "slogans", :force => true do |t|
    t.string   "title"
    t.boolean  "active",     :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "status", :force => true do |t|
    t.integer  "user_id"
    t.string   "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "status", ["user_id"], :name => "index_status_on_user_id"

  create_table "swigs", :force => true do |t|
    t.integer  "user_id"
    t.integer  "bar_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "reward_point"
  end

  add_index "swigs", ["bar_id"], :name => "index_swigs_on_bar_id"
  add_index "swigs", ["user_id"], :name => "index_swigs_on_user_id"

  create_table "user_popularities", :force => true do |t|
    t.integer  "user_id"
    t.integer  "bar_id"
    t.integer  "total_invited",  :default => 0
    t.integer  "total_attendee", :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_popularities", ["user_id", "bar_id"], :name => "index_user_popularities_on_user_id_and_bar_id"

  create_table "user_rewards", :force => true do |t|
    t.integer  "reward_id"
    t.integer  "earned",       :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "swig_id"
    t.integer  "total"
    t.integer  "recipient_id"
  end

  add_index "user_rewards", ["recipient_id"], :name => "index_user_rewards_on_recipient_id"
  add_index "user_rewards", ["reward_id"], :name => "index_user_rewards_on_user_id_and_reward_id"
  add_index "user_rewards", ["swig_id"], :name => "index_user_rewards_on_swig_id"

  create_table "users", :force => true do |t|
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",     :limit => 128, :default => ""
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "authentication_token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "name"
    t.string   "address"
    t.string   "zip_code"
    t.string   "phone_number"
    t.string   "city"
    t.string   "state_abbr"
    t.string   "country_abbr"
    t.string   "slug"
    t.string   "activity_stream_token"
    t.datetime "last_seen"
    t.string   "invitation_token",       :limit => 60
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
    t.integer  "coupon_id"
    t.string   "service_uid"
    t.date     "dob"
  end

  add_index "users", ["authentication_token"], :name => "index_users_on_authentication_token", :unique => true
  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["coupon_id"], :name => "index_users_on_coupon_id"
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["invitation_token"], :name => "index_users_on_invitation_token"
  add_index "users", ["invited_by_id"], :name => "index_users_on_invited_by_id"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["service_uid"], :name => "index_users_on_service_uid"
  add_index "users", ["slug"], :name => "index_users_on_slug", :unique => true

end
