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

ActiveRecord::Schema.define(version: 2018_12_13_175602) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "boards", force: :cascade do |t|
    t.string "trello_ext_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "trello_url"
    t.index ["user_id"], name: "index_boards_on_user_id"
  end

  create_table "cards", force: :cascade do |t|
    t.string "trello_ext_id", null: false
    t.bigint "list_id"
    t.integer "size", default: 2, null: false
    t.bigint "member_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["list_id"], name: "index_cards_on_list_id"
    t.index ["member_id"], name: "index_cards_on_member_id"
  end

  create_table "lists", force: :cascade do |t|
    t.string "trello_ext_id", null: false
    t.bigint "sprint_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "rank"
    t.index ["sprint_id"], name: "index_lists_on_sprint_id"
  end

  create_table "members", force: :cascade do |t|
    t.string "trello_ext_id", null: false
    t.bigint "sprint_id"
    t.boolean "contributor", default: true
    t.integer "days_per_sprint"
    t.integer "total_hours", default: 0, null: false
    t.integer "hours_per_day", default: 8, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "full_name"
    t.string "trello_avatar_url"
    t.index ["sprint_id"], name: "index_members_on_sprint_id"
  end

  create_table "sprints", force: :cascade do |t|
    t.string "trello_ext_id", null: false
    t.date "start_date", null: false
    t.date "end_date", null: false
    t.integer "man_hours", default: 0
    t.bigint "user_id"
    t.string "trello_url", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.index ["user_id"], name: "index_sprints_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "provider"
    t.string "uid"
    t.string "token"
    t.string "full_name"
    t.string "secret"
    t.string "username"
    t.string "trello_avatar_url"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "boards", "users"
  add_foreign_key "cards", "lists"
  add_foreign_key "cards", "members"
  add_foreign_key "lists", "sprints"
  add_foreign_key "members", "sprints"
  add_foreign_key "sprints", "users"
end
