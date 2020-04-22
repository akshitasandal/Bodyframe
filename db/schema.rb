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

ActiveRecord::Schema.define(version: 2020_02_13_044344) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "admin_payouts", force: :cascade do |t|
    t.integer "user_id"
    t.string "amount_requested"
    t.integer "payment", default: 1
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "administrators", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.string "first_name"
    t.string "last_name"
    t.string "remember_token"
    t.datetime "remember_token_expires_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "bank_accounts", force: :cascade do |t|
    t.string "name"
    t.string "bank_name"
    t.string "routing_number"
    t.string "account_number"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "source_id"
  end

  create_table "credit_cards", force: :cascade do |t|
    t.string "cc_number"
    t.string "expiry"
    t.string "cvv"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "customer_name"
    t.string "cc_token"
    t.string "country"
    t.string "zipcode"
    t.string "card_id"
    t.string "card_type"
    t.string "source_id"
    t.integer "status", default: 1
    t.index ["user_id"], name: "index_credit_cards_on_user_id"
  end

  create_table "device_tokens", force: :cascade do |t|
    t.integer "user_id"
    t.string "device_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "to_user_id"
    t.string "device_type"
  end

  create_table "faqs", force: :cascade do |t|
    t.text "question"
    t.text "answer"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "invitations", force: :cascade do |t|
    t.string "full_name"
    t.string "phone"
    t.integer "trainer_id"
    t.integer "plan"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "twilio_response", default: ""
    t.integer "user_type"
    t.string "email"
    t.decimal "monthly_amount"
    t.integer "session_count"
    t.decimal "session_amount"
    t.decimal "per_session_amount"
    t.index ["trainer_id"], name: "index_invitations_on_trainer_id"
  end

  create_table "meal_categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "meals", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.datetime "meal_time"
    t.integer "protein"
    t.integer "carbs"
    t.integer "fat"
    t.string "file"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "client_id"
    t.integer "meal_category_id"
    t.string "video_url"
    t.boolean "done", default: false
    t.integer "calories", default: 0
    t.string "video_thumbnail"
    t.boolean "upload_status", default: false
  end

  create_table "notifications", force: :cascade do |t|
    t.integer "user_id"
    t.integer "to_user_id"
    t.integer "notification_text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "notification_type"
    t.integer "meal_id"
    t.integer "workout_id"
    t.integer "status", default: 0
  end

  create_table "payment_histories", force: :cascade do |t|
    t.integer "credit_card_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "bank_account_id"
    t.datetime "next_payable_date"
    t.integer "client_id"
    t.string "cc_number"
    t.decimal "reward_total"
    t.string "plan"
    t.decimal "amount"
    t.integer "session_count"
    t.decimal "per_session_amount"
    t.integer "admin_payout_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "full_name"
    t.date "dob"
    t.text "address"
    t.string "phone"
    t.string "stripe_id"
    t.integer "sex"
    t.integer "user_type"
    t.string "qb_id"
    t.string "country_code"
    t.string "provider", default: "email", null: false
    t.string "uid", default: "", null: false
    t.boolean "allow_password_change", default: false
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "sign_in_count", default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.json "tokens"
    t.string "referral_code"
    t.integer "trainer_id"
    t.string "weight", default: "0"
    t.string "height", default: "0"
    t.integer "objective", default: 0
    t.string "state"
    t.string "city"
    t.string "zipcode"
    t.integer "subscription", default: 0
    t.string "plan_id"
    t.boolean "status", default: true
    t.string "trainer_coupon_code"
    t.string "subscription_id"
    t.string "charge_id"
    t.string "wallet_amount"
    t.boolean "coupon_used", default: false
    t.string "qbp_access_token"
    t.string "chat_id", default: ""
    t.integer "referrar_id"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true
  end

  create_table "workout_categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "workouts", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.integer "workout_duration"
    t.string "calories_burned"
    t.string "file"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "client_id"
    t.integer "workout_category_id"
    t.string "video_url"
    t.boolean "done", default: false
    t.date "date"
    t.string "video_thumbnail"
    t.boolean "upload_status", default: false
    t.index ["date"], name: "index_workouts_on_date"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
end
