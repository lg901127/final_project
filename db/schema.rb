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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160807012344) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "badges_sashes", force: :cascade do |t|
    t.integer  "badge_id"
    t.integer  "sash_id"
    t.boolean  "notified_user", default: false
    t.datetime "created_at"
  end

  add_index "badges_sashes", ["badge_id", "sash_id"], name: "index_badges_sashes_on_badge_id_and_sash_id", using: :btree
  add_index "badges_sashes", ["badge_id"], name: "index_badges_sashes_on_badge_id", using: :btree
  add_index "badges_sashes", ["sash_id"], name: "index_badges_sashes_on_sash_id", using: :btree

  create_table "enemies", force: :cascade do |t|
    t.string   "name"
    t.integer  "level"
    t.integer  "xp"
    t.integer  "gold"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "enemy_stats", force: :cascade do |t|
    t.integer  "enemy_id"
    t.integer  "stat_id"
    t.integer  "value",      default: 1
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "enemy_stats", ["enemy_id"], name: "index_enemy_stats_on_enemy_id", using: :btree
  add_index "enemy_stats", ["stat_id"], name: "index_enemy_stats_on_stat_id", using: :btree

  create_table "game_character_attributes", force: :cascade do |t|
    t.integer  "game_character_id"
    t.integer  "stat_id"
    t.integer  "value",             default: 1
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  add_index "game_character_attributes", ["game_character_id"], name: "index_game_character_attributes_on_game_character_id", using: :btree
  add_index "game_character_attributes", ["stat_id"], name: "index_game_character_attributes_on_stat_id", using: :btree

  create_table "game_character_items", force: :cascade do |t|
    t.integer  "game_character_id"
    t.integer  "item_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "game_character_items", ["game_character_id"], name: "index_game_character_items_on_game_character_id", using: :btree
  add_index "game_character_items", ["item_id"], name: "index_game_character_items_on_item_id", using: :btree

  create_table "game_characters", force: :cascade do |t|
    t.string   "name"
    t.integer  "level",             default: 1
    t.integer  "xp",                default: 0
    t.integer  "gold",              default: 0
    t.integer  "user_id"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "uid"
    t.string   "provider"
    t.string   "fitbit_token"
    t.text     "fitbit_raw_data"
    t.integer  "calories"
    t.integer  "steps"
    t.integer  "token_expires_at"
    t.integer  "energy",            default: 100
    t.integer  "sedentary_minutes", default: 0
    t.string   "image"
    t.integer  "sash_id"
  end

  add_index "game_characters", ["user_id"], name: "index_game_characters_on_user_id", using: :btree

  create_table "item_stats", force: :cascade do |t|
    t.integer  "item_id"
    t.integer  "stat_id"
    t.integer  "value",      default: 0
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "item_stats", ["item_id"], name: "index_item_stats_on_item_id", using: :btree
  add_index "item_stats", ["stat_id"], name: "index_item_stats_on_stat_id", using: :btree

  create_table "items", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "price"
    t.string   "image"
  end

  create_table "merit_actions", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "action_method"
    t.integer  "action_value"
    t.boolean  "had_errors",    default: false
    t.string   "target_model"
    t.integer  "target_id"
    t.text     "target_data"
    t.boolean  "processed",     default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "merit_activity_logs", force: :cascade do |t|
    t.integer  "action_id"
    t.string   "related_change_type"
    t.integer  "related_change_id"
    t.string   "description"
    t.datetime "created_at"
  end

  create_table "merit_score_points", force: :cascade do |t|
    t.integer  "score_id"
    t.integer  "num_points", default: 0
    t.string   "log"
    t.datetime "created_at"
  end

  create_table "merit_scores", force: :cascade do |t|
    t.integer "sash_id"
    t.string  "category", default: "default"
  end

  create_table "sashes", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "stats", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "full_name"
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_foreign_key "enemy_stats", "enemies"
  add_foreign_key "enemy_stats", "stats"
  add_foreign_key "game_character_attributes", "game_characters"
  add_foreign_key "game_character_attributes", "stats"
  add_foreign_key "game_character_items", "game_characters"
  add_foreign_key "game_character_items", "items"
  add_foreign_key "game_characters", "users"
  add_foreign_key "item_stats", "items"
  add_foreign_key "item_stats", "stats"
end
