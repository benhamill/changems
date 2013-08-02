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

ActiveRecord::Schema.define(version: 20120129064819) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "ruby_gems", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "featured",   default: false
  end

  add_index "ruby_gems", ["featured"], name: "index_ruby_gems_on_featured", using: :btree
  add_index "ruby_gems", ["name"], name: "index_ruby_gems_on_name", unique: true, using: :btree

  create_table "versions", force: true do |t|
    t.string   "number"
    t.integer  "ruby_gem_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "major",          default: 0
    t.integer  "minor",          default: 0
    t.integer  "patch",          default: 0
    t.string   "prerelease"
    t.text     "release_notes",               null: false
    t.text     "file_extension", default: ""
  end

  add_index "versions", ["major", "minor", "patch", "prerelease"], name: "index_versions_on_major_and_minor_and_patch_and_prerelease", using: :btree
  add_index "versions", ["number", "ruby_gem_id"], name: "index_versions_on_number_and_ruby_gem_id", unique: true, using: :btree

end
