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

ActiveRecord::Schema.define(version: 2022_07_12_033242) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "pull_requests", force: :cascade do |t|
    t.string "title"
    t.string "full_name"
    t.bigint "repository_id"
    t.integer "number"
    t.bigint "user_id"
    t.integer "state", default: 0
    t.string "current_reviewer"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "reviewer_picon"
    t.index ["repository_id", "number"], name: "index_pull_requests_on_repository_id_and_number", unique: true
    t.index ["user_id"], name: "index_pull_requests_on_user_id"
  end

  create_table "repositories", force: :cascade do |t|
    t.string "full_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rooms", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "bot_api_token"
    t.string "slack_id"
  end

  create_table "subscriptions", force: :cascade do |t|
    t.integer "repository_id"
    t.integer "user_id"
    t.string "subscriber"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "login"
    t.string "avatar"
    t.string "email"
    t.integer "role", default: 0
    t.bigint "chatwork"
    t.bigint "room_id"
    t.integer "merged", default: 0
    t.jsonb "settings"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "admin", default: false
    t.integer "language", default: 0
    t.string "slack_id"
    t.index ["chatwork"], name: "index_users_on_chatwork", unique: true
    t.index ["room_id"], name: "index_users_on_room_id"
  end

end
