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

ActiveRecord::Schema.define(version: 20130917211303) do

  create_table "datasets", force: true do |t|
    t.string  "dataset",              limit: 64,  default: "", null: false
    t.string  "dataset_description",  limit: 100, default: "", null: false
    t.integer "env_sample_source_id"
    t.integer "project_id"
  end

  add_index "datasets", ["dataset", "project_id"], name: "dataset_project", unique: true, using: :btree
  add_index "datasets", ["env_sample_source_id"], name: "dataset_fk_env_sample_source_id", using: :btree
  add_index "datasets", ["project_id"], name: "dataset_fk_project_id", using: :btree

  create_table "domains", force: true do |t|
    t.string "domain", limit: 300, default: "", null: false
  end

  add_index "domains", ["domain"], name: "domain", unique: true, using: :btree

  create_table "env_sample_sources", force: true do |t|
    t.integer "env_sample_source_id", limit: 1,  default: 0, null: false
    t.string  "env_source_name",      limit: 50
  end

  add_index "env_sample_sources", ["env_source_name"], name: "env_source_name", unique: true, using: :btree

  create_table "families", force: true do |t|
    t.string "family", limit: 300, default: "", null: false
  end

  add_index "families", ["family"], name: "family", unique: true, using: :btree

  create_table "genera", force: true do |t|
    t.string "genus", limit: 300, default: "", null: false
  end

  add_index "genera", ["genus"], name: "genus", unique: true, using: :btree

  create_table "klasses", force: true do |t|
    t.string "klass", limit: 300, default: "", null: false
  end

  add_index "klasses", ["klass"], name: "klass", unique: true, using: :btree

  create_table "orders", force: true do |t|
    t.string "order", limit: 300, default: "", null: false
  end

  add_index "orders", ["order"], name: "order", unique: true, using: :btree

  create_table "phylums", force: true do |t|
    t.string "phylum", limit: 300, default: "", null: false
  end

  add_index "phylums", ["phylum"], name: "phylum", unique: true, using: :btree

  create_table "projects", force: true do |t|
    t.string  "project",             limit: 32, default: "", null: false
    t.string  "title",               limit: 64, default: "", null: false
    t.string  "project_description",            default: "", null: false
    t.string  "rev_project_name",    limit: 32, default: "", null: false
    t.string  "funding",             limit: 64, default: "", null: false
    t.integer "user_id"
  end

  add_index "projects", ["project"], name: "project", unique: true, using: :btree
  add_index "projects", ["rev_project_name"], name: "rev_project_name", unique: true, using: :btree
  add_index "projects", ["user_id"], name: "user_id", using: :btree

  create_table "ranks", force: true do |t|
    t.string  "rank",        limit: 32, default: "", null: false
    t.integer "rank_number", limit: 1
  end

  add_index "ranks", ["rank"], name: "rank", unique: true, using: :btree

  create_table "sequence_pdr_infos", force: true do |t|
    t.integer  "dataset_id",                             null: false
    t.integer  "sequence_id",                            null: false
    t.integer  "seq_count",                              null: false
    t.string   "classifier",  limit: 4, default: "GAST"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sequence_pdr_infos", ["dataset_id", "sequence_id"], name: "uniq_seq_pd", unique: true, using: :btree
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

  create_table "species", force: true do |t|
    t.string "species", default: "", null: false
  end

  add_index "species", ["species"], name: "species", unique: true, using: :btree

  create_table "strains", force: true do |t|
    t.string "strain", limit: 300, default: "", null: false
  end

  add_index "strains", ["strain"], name: "strain", unique: true, using: :btree

  create_table "taxonomies", force: true do |t|
    t.integer  "domain_id"
    t.integer  "phylum_id"
    t.integer  "klass_id"
    t.integer  "order_id"
    t.integer  "family_id"
    t.integer  "genus_id"
    t.integer  "species_id"
    t.integer  "strain_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "taxonomies", ["domain_id", "phylum_id", "klass_id", "order_id", "family_id", "genus_id", "species_id", "strain_id"], name: "all_names", unique: true, using: :btree
  add_index "taxonomies", ["family_id"], name: "taxonomy_fk_family_id", using: :btree
  add_index "taxonomies", ["genus_id"], name: "taxonomy_fk_genus_id", using: :btree
  add_index "taxonomies", ["klass_id"], name: "taxonomy_fk_klass_id", using: :btree
  add_index "taxonomies", ["order_id"], name: "taxonomy_fk_order_id", using: :btree
  add_index "taxonomies", ["phylum_id"], name: "taxonomy_fk_phylum_id", using: :btree
  add_index "taxonomies", ["species_id"], name: "taxonomy_fk_species_id", using: :btree
  add_index "taxonomies", ["strain_id"], name: "taxonomy_fk_strain_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "username",               limit: 20
    t.string   "email",                  limit: 64,  default: "", null: false
    t.string   "institution",            limit: 128
    t.string   "first_name",             limit: 20
    t.string   "last_name",              limit: 20
    t.integer  "active",                 limit: 1,   default: 0,  null: false
    t.integer  "security_level",         limit: 1,   default: 50, null: false
    t.string   "encrypted_password",                 default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
  end

  add_index "users", ["first_name", "last_name", "email", "institution"], name: "contact_email_inst", unique: true, using: :btree
  add_index "users", ["institution"], name: "institution", length: {"institution"=>15}, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["username"], name: "username", unique: true, using: :btree

end
