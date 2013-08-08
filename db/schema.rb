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

ActiveRecord::Schema.define(version: 20130808152306) do

  create_table "contacts", force: true do |t|
    t.string   "contact",     limit: 32
    t.string   "email",       limit: 64
    t.string   "institution", limit: 128
    t.string   "vamps_name",  limit: 20
    t.string   "first_name",  limit: 20
    t.string   "last_name",   limit: 20
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "contacts", ["contact", "email", "institution"], name: "contact_email_inst", unique: true, using: :btree
  add_index "contacts", ["institution"], name: "institution", length: {"institution"=>15}, using: :btree

  create_table "contacts_users", id: false, force: true do |t|
    t.integer "contact_id", null: false
    t.integer "user_id",    null: false
  end

  add_index "contacts_users", ["contact_id", "user_id"], name: "contact_id_user_id", unique: true, using: :btree
  add_index "contacts_users", ["user_id"], name: "user_id", using: :btree

  create_table "dna_regions", force: true do |t|
    t.string "dna_region", limit: 32
  end

  add_index "dna_regions", ["dna_region"], name: "dna_region", unique: true, using: :btree

  create_table "env_sample_sources", force: true do |t|
    t.string "env_source_name", limit: 50
  end

  add_index "env_sample_sources", ["env_source_name"], name: "env_source_name", unique: true, using: :btree

  create_table "primer_suites", force: true do |t|
    t.string "primer_suite", limit: 25, default: "", null: false
  end

  add_index "primer_suites", ["primer_suite"], name: "primer_suite", unique: true, using: :btree

  create_table "primers", force: true do |t|
    t.string "primer",       limit: 16, default: "", null: false
    t.string "direction",    limit: 1,               null: false
    t.string "sequence",     limit: 64, default: "", null: false
    t.string "region",       limit: 16, default: "", null: false
    t.string "original_seq", limit: 64, default: "", null: false
    t.string "domain",       limit: 8
  end

  add_index "primers", ["primer"], name: "primer", unique: true, using: :btree

  create_table "projects", force: true do |t|
    t.string  "project",             limit: 32, default: "", null: false
    t.string  "title",               limit: 64, default: "", null: false
    t.string  "project_description",            default: "", null: false
    t.string  "rev_project_name",    limit: 32, default: "", null: false
    t.string  "funding",             limit: 64, default: "", null: false
    t.integer "contact_id"
  end

  add_index "projects", ["contact_id"], name: "contact_id", using: :btree
  add_index "projects", ["project"], name: "project", unique: true, using: :btree
  add_index "projects", ["rev_project_name"], name: "rev_project_name", unique: true, using: :btree

  create_table "ranks", force: true do |t|
    t.string "rank", limit: 32, default: "", null: false
  end

  add_index "ranks", ["rank"], name: "rank", unique: true, using: :btree

  create_table "sequences", force: true do |t|
    t.binary   "sequence_comp", limit: 2147483647
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sequences", ["sequence_comp"], name: "sequence_comp", unique: true, length: {"sequence_comp"=>400}, using: :btree

  create_table "taxonomies", force: true do |t|
    t.string   "taxonomy",   limit: 300
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "taxonomies", ["taxonomy"], name: "taxonomy", unique: true, length: {"taxonomy"=>255}, using: :btree

  create_table "users", force: true do |t|
    t.string  "user",           limit: 20
    t.string  "passwd",         limit: 50
    t.integer "active",         limit: 2
    t.integer "security_level", limit: 2
  end

  add_index "users", ["user"], name: "user", unique: true, using: :btree

end
