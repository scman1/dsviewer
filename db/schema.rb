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

ActiveRecord::Schema.define(version: 2019_02_18_151522) do

  create_table "credentials", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.string "url"
    t.string "login"
    t.string "password"
    t.string "server_type"
    t.boolean "in_use"
    t.boolean "default"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "dsdata", force: :cascade do |t|
    t.string "ds_id"
    t.datetime "creation_datetime"
    t.string "creator"
    t.integer "mids_level"
    t.string "scientific_name"
    t.string "common_name"
    t.string "country"
    t.string "locality"
    t.string "recorded_by"
    t.date "collection_date"
    t.string "catalog_number"
    t.string "other_catalog_numbers"
    t.string "institution_code"
    t.string "collection_code"
    t.string "stable_identifier"
    t.string "physical_specimen_id"
    t.string "determinations"
    t.string "cat_of_life_reference"
    t.string "image_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
