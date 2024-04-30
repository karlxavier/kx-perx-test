# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2024_04_30_061057) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "point_transactions", force: :cascade do |t|
    t.bigint "points_issuing_rule_id", null: false
    t.bigint "transaction_id", null: false
    t.bigint "user_id", null: false
    t.string "state"
    t.datetime "expires_at"
    t.datetime "used_at"
    t.integer "current_points", default: 0
    t.integer "total_points", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["points_issuing_rule_id"], name: "index_point_transactions_on_points_issuing_rule_id"
    t.index ["transaction_id"], name: "index_point_transactions_on_transaction_id"
    t.index ["user_id"], name: "index_point_transactions_on_user_id"
  end

  create_table "point_transactions_reward_transactions", id: false, force: :cascade do |t|
    t.bigint "reward_transaction_id", null: false
    t.bigint "point_transaction_id", null: false
  end

  create_table "points_issuing_rules", force: :cascade do |t|
    t.jsonb "conditions", default: [{}]
    t.jsonb "calculations", default: [{}]
    t.string "state"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reward_transactions", force: :cascade do |t|
    t.bigint "rewards_issuing_rule_id", null: false
    t.bigint "user_id", null: false
    t.string "state"
    t.datetime "redeem_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "rewardable_type"
    t.bigint "rewardable_id"
    t.index ["rewardable_type", "rewardable_id"], name: "index_reward_transactions_on_rewardable"
    t.index ["rewards_issuing_rule_id"], name: "index_reward_transactions_on_rewards_issuing_rule_id"
    t.index ["user_id"], name: "index_reward_transactions_on_user_id"
  end

  create_table "rewards", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.integer "reward_points", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rewards_issuing_rules", force: :cascade do |t|
    t.jsonb "conditions", default: [{}]
    t.string "state"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "reward_id", null: false
    t.index ["reward_id"], name: "index_rewards_issuing_rules_on_reward_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "amount"
    t.string "currency"
    t.string "state"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_transactions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.date "birthday"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "loyalty_tier", null: false
  end

  add_foreign_key "point_transactions", "points_issuing_rules"
  add_foreign_key "point_transactions", "transactions"
  add_foreign_key "point_transactions", "users"
  add_foreign_key "reward_transactions", "rewards_issuing_rules"
  add_foreign_key "reward_transactions", "users"
  add_foreign_key "rewards_issuing_rules", "rewards"
  add_foreign_key "transactions", "users"
end
