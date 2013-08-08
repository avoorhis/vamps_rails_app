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

ActiveRecord::Schema.define(version: 20130808184526) do

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

  create_table "datasets", force: true do |t|
    t.string  "dataset",              limit: 64,  default: "",  null: false
    t.string  "dataset_description",  limit: 100, default: "",  null: false
    t.integer "reads_in_dataset",     limit: 3,   default: 0,   null: false
    t.string  "has_sequence",         limit: 1,   default: "0", null: false
    t.integer "env_sample_source_id"
    t.integer "project_id"
    t.string  "date_trimmed",         limit: 10,  default: "",  null: false
  end

  add_index "datasets", ["dataset", "project_id"], name: "dataset_project", unique: true, using: :btree
  add_index "datasets", ["env_sample_source_id"], name: "dataset_fk_env_sample_source_id", using: :btree
  add_index "datasets", ["project_id"], name: "dataset_fk_project_id", using: :btree

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

  create_table "primer_suites_primers", id: false, force: true do |t|
    t.integer "primer_id",       null: false
    t.integer "primer_suite_id", null: false
  end

  add_index "primer_suites_primers", ["primer_id"], name: "primer_suites_primer_fk_primer_id", using: :btree
  add_index "primer_suites_primers", ["primer_suite_id"], name: "primer_suites_primer_fk_primer_suite_id", using: :btree

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

  create_table "run_infos", force: true do |t|
    t.integer  "run_key_id",                                  null: false
    t.integer  "run_id",                                      null: false
    t.integer  "lane",            limit: 1,  default: 0,      null: false
    t.integer  "dataset_id",                                  null: false
    t.integer  "project_id",                                  null: false
    t.string   "tubelabel",       limit: 32, default: "",     null: false
    t.string   "barcode",         limit: 4,  default: "",     null: false
    t.string   "adaptor",         limit: 3,  default: "",     null: false
    t.integer  "dna_region_id",                               null: false
    t.string   "amp_operator",    limit: 5,  default: "",     null: false
    t.string   "seq_operator",    limit: 5,  default: "",     null: false
    t.string   "barcode_index",   limit: 12, default: "",     null: false
    t.string   "overlap",         limit: 8,  default: "none", null: false
    t.integer  "insert_size",     limit: 2,  default: 0,      null: false
    t.integer  "read_length",     limit: 2,                   null: false
    t.integer  "primer_suite_id",                             null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "run_infos", ["dataset_id"], name: "run_info_fk_dataset_id", using: :btree
  add_index "run_infos", ["dna_region_id"], name: "run_info_fk_dna_region_id", using: :btree
  add_index "run_infos", ["primer_suite_id"], name: "run_info_fk_primer_suite_id", using: :btree
  add_index "run_infos", ["project_id"], name: "run_info_fk_project_id", using: :btree
  add_index "run_infos", ["run_id", "run_key_id", "barcode_index", "lane"], name: "uniq_key", unique: true, using: :btree
  add_index "run_infos", ["run_key_id"], name: "run_info_fk_run_key_id", using: :btree

  create_table "run_keys", force: true do |t|
    t.string "run_key", limit: 25, default: "", null: false
  end

  add_index "run_keys", ["run_key"], name: "run_key", unique: true, using: :btree

  create_table "runs", force: true do |t|
    t.string "run",          limit: 16, default: "", null: false
    t.string "run_prefix",   limit: 7,  default: "", null: false
    t.date   "date_trimmed"
  end

  add_index "runs", ["run"], name: "run", unique: true, using: :btree

  create_table "sequence_pdr_infos", force: true do |t|
    t.integer  "run_info_id", null: false
    t.integer  "sequence_id", null: false
    t.integer  "seq_count",   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sequence_pdr_infos", ["run_info_id", "sequence_id"], name: "uniq_seq_pdr", unique: true, using: :btree
  add_index "sequence_pdr_infos", ["sequence_id"], name: "sequence_pdr_info_fk_sequence_id", using: :btree

  create_table "sequence_uniq_infos", force: true do |t|
    t.integer  "sequence_id",                                       null: false
    t.integer  "taxonomy_id",                                       null: false
    t.decimal  "gast_distance", precision: 7, scale: 5,             null: false
    t.integer  "refssu_id",                                         null: false
    t.integer  "refssu_count",                          default: 0, null: false
    t.integer  "rank_id",                                           null: false
    t.text     "refhvr_ids",                                        null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sequence_uniq_infos", ["rank_id"], name: "sequence_uniq_info_fk_rank_id", using: :btree
  add_index "sequence_uniq_infos", ["refssu_id"], name: "refssu_id", using: :btree
  add_index "sequence_uniq_infos", ["sequence_id"], name: "sequence_id", unique: true, using: :btree
  add_index "sequence_uniq_infos", ["taxonomy_id"], name: "sequence_uniq_info_fk_taxonomy_id", using: :btree

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

  add_index "taxonomies", ["taxonomy"], name: "taxonomy", unique: true, using: :btree

  create_table "users", force: true do |t|
    t.string  "user",           limit: 20
    t.string  "passwd",         limit: 50
    t.integer "active",         limit: 1,  default: 0,  null: false
    t.integer "security_level", limit: 1,  default: 50, null: false
  end

  add_index "users", ["user"], name: "user", unique: true, using: :btree

end
