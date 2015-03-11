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

ActiveRecord::Schema.define(version: 6) do

  create_table "accounts", force: :cascade do |t|
    t.string   "name"
    t.string   "surname"
    t.string   "email"
    t.string   "crypted_password"
    t.string   "role"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "competitions", force: :cascade do |t|
    t.integer "cid"
    t.string  "name"
    t.string  "category"
    t.string  "isu_hp"
    t.integer "year"
    t.string  "city"
    t.string  "noc"
    t.date    "start_date"
    t.date    "end_date"
  end

  create_table "components", force: :cascade do |t|
    t.string  "name"
    t.float   "factor"
    t.float   "judge_scores"
    t.float   "score_of_panels"
    t.integer "score_id"
  end

  add_index "components", ["score_id"], name: "index_components_on_score_id"

  create_table "elements", force: :cascade do |t|
    t.integer  "number"
    t.string   "executed_element"
    t.string   "info"
    t.string   "credit"
    t.float    "bv"
    t.float    "goe"
    t.string   "judge_scores"
    t.float    "score_of_panels"
    t.integer  "score_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "elements", ["score_id"], name: "index_elements_on_score_id"

  create_table "scores", force: :cascade do |t|
    t.string  "score_name"
    t.integer "sid"
    t.string  "discipline"
    t.string  "segment"
    t.date    "date"
    t.string  "season"
    t.integer "ranking"
    t.string  "noc"
    t.integer "skating_order"
    t.float   "tss"
    t.float   "tes"
    t.float   "pcs"
    t.integer "deductions"
    t.float   "total_bv"
    t.string  "pdf"
    t.integer "skater_id"
    t.integer "competition_id"
  end

  add_index "scores", ["competition_id"], name: "index_scores_on_competition_id"
  add_index "scores", ["skater_id"], name: "index_scores_on_skater_id"

  create_table "skaters", force: :cascade do |t|
    t.integer  "isu_number"
    t.string   "name"
    t.string   "noc"
    t.string   "country"
    t.string   "discipline"
    t.string   "bio"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
