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

ActiveRecord::Schema.define(version: 2018_12_23_204915) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "boards", force: :cascade do |t|
    t.string "trello_ext_id"
    t.bigint "user_id"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "trello_url"
    t.index ["user_id"], name: "index_boards_on_user_id"
  end

  create_table "cards", force: :cascade do |t|
    t.string "trello_ext_id", null: false
    t.bigint "list_id"
    t.integer "size", default: 0, null: false
    t.bigint "member_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["list_id"], name: "index_cards_on_list_id"
    t.index ["member_id"], name: "index_cards_on_member_id"
  end

  create_table "conversions", force: :cascade do |t|
    t.bigint "sprint_id"
    t.integer "xs", default: 1, null: false
    t.integer "s", default: 2, null: false
    t.integer "m", default: 4, null: false
    t.integer "l", default: 8, null: false
    t.integer "xl", default: 16, null: false
    t.integer "xxl", default: 32, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sprint_id"], name: "index_conversions_on_sprint_id"
  end

  create_table "lists", force: :cascade do |t|
    t.string "trello_ext_id", null: false
    t.string "name"
    t.bigint "sprint_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "rank"
    t.index ["sprint_id"], name: "index_lists_on_sprint_id"
  end

  create_table "member_stats", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "member_id"
    t.string "description"
    t.integer "available_hours"
    t.integer "weighted_cards_count"
    t.jsonb "weighted_cards_per_size"
    t.jsonb "weighted_cards_per_rank"
    t.jsonb "weighted_cards_per_size_per_rank"
    t.jsonb "weighted_cards_per_size_per_rank_ck"
    t.jsonb "conversion_per_size_per_rank"
    t.jsonb "conversion_per_size_per_rank_ck"
    t.jsonb "conversion_per_size"
    t.jsonb "conversion_per_rank"
    t.integer "total_conversion"
    t.integer "total_story_points"
    t.float "progress"
    t.integer "story_points_progress"
    t.datetime "datetime_at_post"
    t.index ["member_id"], name: "index_member_stats_on_member_id"
  end

  create_table "members", force: :cascade do |t|
    t.string "trello_ext_id", null: false
    t.bigint "sprint_id"
    t.boolean "contributor", default: true
    t.integer "days_per_sprint"
    t.integer "available_hours", default: 0, null: false
    t.integer "hours_per_day", default: 8, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "full_name"
    t.string "trello_avatar_url"
    t.index ["sprint_id"], name: "index_members_on_sprint_id"
  end

  create_table "sprint_stats", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "datetime_at_post"
    t.integer "available_man_hours"
    t.integer "total_contributors"
    t.integer "total_days"
    t.integer "total_days_from_start"
    t.integer "total_days_to_end"
    t.integer "total_ranks"
    t.integer "total_cards"
    t.jsonb "cards_per_size"
    t.integer "total_weighted_cards"
    t.jsonb "weighted_cards_per_size"
    t.jsonb "weighted_cards_per_rank"
    t.integer "total_story_points"
    t.jsonb "weighted_cards_per_contributor"
    t.jsonb "story_points_per_contributor"
    t.jsonb "story_points_per_size"
    t.jsonb "conversion_per_size"
    t.integer "total_conversion"
    t.jsonb "conversion_per_size_per_contributor"
    t.jsonb "conversion_per_size_per_contributor_ck"
    t.jsonb "weighted_cards_per_size_per_contributor"
    t.jsonb "weighted_cards_per_size_per_contributor_ck"
    t.jsonb "conversion_per_contributor"
    t.jsonb "available_hours_per_contributor"
    t.jsonb "merged_conversion_per_contributor"
    t.jsonb "weighted_cards_per_size_per_rank"
    t.jsonb "weighted_cards_per_size_per_rank_ck"
    t.jsonb "conversion_per_size_per_rank"
    t.jsonb "conversion_per_size_per_rank_ck"
    t.jsonb "conversion_per_rank"
    t.jsonb "progress_conversion_per_rank"
    t.jsonb "merged_conversion_per_rank"
    t.integer "progress_conversion"
    t.float "progress"
    t.integer "story_points_progress"
    t.bigint "sprint_id"
    t.string "description"
    t.index ["sprint_id"], name: "index_sprint_stats_on_sprint_id"
  end

  create_table "sprints", force: :cascade do |t|
    t.string "trello_ext_id", null: false
    t.date "start_date", null: false
    t.date "end_date", null: false
    t.integer "available_man_hours", default: 0
    t.bigint "user_id"
    t.string "trello_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.bigint "webhook_id"
    t.index ["user_id"], name: "index_sprints_on_user_id"
    t.index ["webhook_id"], name: "index_sprints_on_webhook_id"
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

  create_table "webhooks", force: :cascade do |t|
    t.bigint "user_id"
    t.string "description"
    t.string "ext_board_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_webhooks_on_user_id"
  end

  add_foreign_key "boards", "users"
  add_foreign_key "cards", "lists"
  add_foreign_key "cards", "members"
  add_foreign_key "conversions", "sprints"
  add_foreign_key "lists", "sprints"
  add_foreign_key "member_stats", "members"
  add_foreign_key "members", "sprints"
  add_foreign_key "sprint_stats", "sprints"
  add_foreign_key "sprints", "users"
  add_foreign_key "sprints", "webhooks"
  add_foreign_key "webhooks", "users"
end
