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

ActiveRecord::Schema.define(version: 2020_04_04_065143) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "price_changes", force: :cascade do |t|
    t.bigint "property_id", null: false
    t.integer "updated_price", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["property_id"], name: "index_price_changes_on_property_id"
  end

  create_table "properties", force: :cascade do |t|
    t.string "description"
    t.string "location"
    t.integer "current_price"
    t.integer "change_in_price"
    t.string "remote_id", null: false
    t.boolean "watched"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["remote_id"], name: "index_properties_on_remote_id", unique: true
  end

  create_table "searches", force: :cascade do |t|
    t.string "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "domain"
  end

  add_foreign_key "price_changes", "properties", on_delete: :cascade
end
