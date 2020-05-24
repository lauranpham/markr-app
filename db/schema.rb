# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_05_22_051101) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "results", force: :cascade do |t|
    t.integer "count"
    t.float "mean"
    t.float "stddev"
    t.float "min"
    t.float "max"
    t.float "p25"
    t.float "p50"
    t.float "p75"
    t.integer "available_marks"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "scores", force: :cascade do |t|
    t.integer "obtained"
    t.integer "available"
    t.bigint "result_id", null: false
    t.bigint "student_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["result_id"], name: "index_scores_on_result_id"
    t.index ["student_id"], name: "index_scores_on_student_id"
  end

  create_table "students", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "scores", "results"
  add_foreign_key "scores", "students"
end
