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

ActiveRecord::Schema.define(version: 20130708152256) do

  create_table "classes", primary_key: "class_id", force: true do |t|
    t.string "class", limit: 34, default: "", null: false
  end

  add_index "classes", ["class"], name: "class", unique: true, using: :btree

  create_table "contacts", primary_key: "contact_id", force: true do |t|
    t.string "first_name",  limit: 20,  default: ""
    t.string "last_name",   limit: 20,  default: ""
    t.string "email",       limit: 64,  default: "", null: false
    t.string "institution", limit: 128, default: "", null: false
    t.string "contact",     limit: 64,               null: false
  end

  add_index "contacts", ["contact", "email", "institution"], name: "contact_email_inst", unique: true, using: :btree

  create_table "datasets", primary_key: "dataset_id", force: true do |t|
    t.string   "dataset",             limit: 64,  default: "", null: false
    t.string   "dataset_description", limit: 100, default: "", null: false
    t.integer  "reads_in_dataset",    limit: 3,                null: false
    t.string   "has_sequence",        limit: 1,                null: false
    t.integer  "project_id",          limit: 3,                null: false
    t.string   "date_trimmed",        limit: 10,               null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "datasets", ["dataset", "dataset_description", "reads_in_dataset", "has_sequence", "project_id", "date_trimmed"], name: "dataset_project_info", unique: true, using: :btree
  add_index "datasets", ["project_id"], name: "project_id", using: :btree

  create_table "env_sample_source", primary_key: "env_sample_source_id", force: true do |t|
    t.string "env_source_name", limit: 50, default: "", null: false
  end

  add_index "env_sample_source", ["env_source_name"], name: "env_source_name", unique: true, using: :btree

  create_table "families", primary_key: "family_id", force: true do |t|
    t.string "family", limit: 37, default: "", null: false
  end

  add_index "families", ["family"], name: "family", unique: true, using: :btree

  create_table "genuses", primary_key: "genus_id", force: true do |t|
    t.string "genus", limit: 60, default: "", null: false
  end

  add_index "genuses", ["genus"], name: "genus", unique: true, using: :btree

  create_table "orders", primary_key: "orderx_id", force: true do |t|
    t.string "orderx", limit: 34, default: "", null: false
  end

  add_index "orders", ["orderx"], name: "orderx", unique: true, using: :btree

  create_table "phyla", primary_key: "phylum_id", force: true do |t|
    t.string "phylum", limit: 34, default: "", null: false
  end

  add_index "phyla", ["phylum"], name: "phylum", unique: true, using: :btree

  create_table "project_dataset", primary_key: "project_dataset_id", force: true do |t|
    t.string  "project_dataset", limit: 100, default: "", null: false
    t.integer "dataset_id",      limit: 2,                null: false
    t.integer "project_id",      limit: 3,                null: false
  end

  add_index "project_dataset", ["dataset_id"], name: "dataset_id", using: :btree
  add_index "project_dataset", ["project_dataset"], name: "project_dataset", unique: true, using: :btree
  add_index "project_dataset", ["project_id"], name: "project_id", using: :btree

  create_table "projects", primary_key: "project_id", force: true do |t|
    t.string   "project",              limit: 64, default: "", null: false
    t.string   "title",                limit: 64, default: "", null: false
    t.string   "project_description",             default: "", null: false
    t.string   "funding",              limit: 64, default: "", null: false
    t.integer  "env_sample_source_id", limit: 1,  default: 0,  null: false
    t.integer  "contact_id",           limit: 2,               null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "projects", ["contact_id"], name: "contact_id", using: :btree
  add_index "projects", ["env_sample_source_id"], name: "env_sample_source_id", using: :btree
  add_index "projects", ["project"], name: "project", unique: true, using: :btree

  create_table "rank_number", primary_key: "rank_number_id", force: true do |t|
    t.integer "rank_number", limit: 1, null: false
    t.integer "rank_id",     limit: 1, null: false
    t.integer "hmp_rank_id", limit: 1, null: false
  end

  add_index "rank_number", ["hmp_rank_id"], name: "hmp_rank_id", using: :btree
  add_index "rank_number", ["rank_id"], name: "rank_id", using: :btree
  add_index "rank_number", ["rank_number", "rank_id"], name: "unique_combination", unique: true, using: :btree
  add_index "rank_number", ["rank_number"], name: "rank_number", using: :btree

  create_table "ranks", primary_key: "rank_id", force: true do |t|
    t.string "rank", limit: 32, default: "", null: false
  end

  add_index "ranks", ["rank"], name: "rank", unique: true, using: :btree

  create_table "read_ids", primary_key: "read_id_id", force: true do |t|
    t.string  "read_id",      limit: 32, default: "", null: false
    t.integer "project_id",   limit: 3,  default: 0,  null: false
    t.integer "dataset_id",   limit: 2,  default: 0,  null: false
    t.integer "sequence_id",             default: 0,  null: false
    t.date    "date_trimmed",                         null: false
    t.integer "seq_count",                            null: false
    t.float   "frequency",                            null: false
  end

  add_index "read_ids", ["dataset_id"], name: "dataset_id", using: :btree
  add_index "read_ids", ["project_id", "dataset_id"], name: "project_dataset_ids", using: :btree
  add_index "read_ids", ["read_id"], name: "read_id", unique: true, using: :btree
  add_index "read_ids", ["sequence_id"], name: "sequence_id", using: :btree

  create_table "sequence_infos", primary_key: "sequence_info_id", force: true do |t|
    t.integer "sequence_id",                                       null: false
    t.integer "taxon_string_id", limit: 3,                         null: false
    t.decimal "gast_distance",             precision: 7, scale: 5, null: false
    t.text    "refhvr_ids",                                        null: false
    t.integer "refssu_id",       limit: 3,                         null: false
    t.integer "refssu_count",                                      null: false
    t.integer "rank_id",         limit: 1,                         null: false
  end

  add_index "sequence_infos", ["refhvr_ids"], name: "refhvr_ids", length: {"refhvr_ids"=>300}, using: :btree
  add_index "sequence_infos", ["sequence_id", "taxon_string_id", "gast_distance", "refhvr_ids"], name: "unique_combined", unique: true, length: {"sequence_id"=>nil, "taxon_string_id"=>nil, "gast_distance"=>nil, "refhvr_ids"=>650}, using: :btree

  create_table "sequences", primary_key: "sequence_id", force: true do |t|
    t.binary "sequence_comp", limit: 2147483647, null: false
  end

  add_index "sequences", ["sequence_comp"], name: "sequence_comp", unique: true, length: {"sequence_comp"=>400}, using: :btree

  create_table "species", primary_key: "species_id", force: true do |t|
    t.string "species", limit: 37, default: "", null: false
  end

  add_index "species", ["species"], name: "species", unique: true, using: :btree

  create_table "strains", primary_key: "strain_id", force: true do |t|
    t.string "strain", limit: 34, default: "", null: false
  end

  add_index "strains", ["strain"], name: "strain", unique: true, using: :btree

  create_table "summed_data_cube", primary_key: "summed_data_cube_id", force: true do |t|
    t.integer "taxon_string_id",    limit: 3, null: false
    t.integer "knt",                limit: 8, null: false
    t.float   "frequency",                    null: false
    t.integer "dataset_count",      limit: 3, null: false
    t.integer "rank_number",        limit: 1, null: false
    t.integer "project_id",         limit: 3, null: false
    t.integer "dataset_id",         limit: 2, null: false
    t.integer "project_dataset_id", limit: 3, null: false
    t.string  "classifier",         limit: 8, null: false
  end

  add_index "summed_data_cube", ["dataset_id"], name: "dataset_id", using: :btree
  add_index "summed_data_cube", ["project_dataset_id", "taxon_string_id"], name: "project_dataset_tax", using: :btree
  add_index "summed_data_cube", ["project_id", "dataset_id"], name: "project_id_dataset_id", using: :btree
  add_index "summed_data_cube", ["rank_number"], name: "rank_number", using: :btree
  add_index "summed_data_cube", ["taxon_string_id", "knt", "frequency", "dataset_count", "rank_number", "project_id", "dataset_id", "project_dataset_id", "classifier"], name: "all_uniq", unique: true, using: :btree
  add_index "summed_data_cube", ["taxon_string_id"], name: "taxon_string_id", using: :btree

  create_table "superkingdoms", primary_key: "superkingdom_id", force: true do |t|
    t.string "superkingdom", limit: 10, default: "", null: false
  end

  add_index "superkingdoms", ["superkingdom"], name: "superkingdom", unique: true, using: :btree

  create_table "taxon_string", primary_key: "taxon_string_id", force: true do |t|
    t.string  "taxon_string",           default: "", null: false
    t.integer "rank_number",  limit: 1,              null: false
  end

  add_index "taxon_string", ["rank_number"], name: "rank_number", using: :btree
  add_index "taxon_string", ["taxon_string"], name: "taxon_string", unique: true, using: :btree

  create_table "taxonomies", primary_key: "taxonomy_id", force: true do |t|
    t.integer "taxon_string_id", limit: 3, null: false
    t.integer "superkingdom_id", limit: 1, null: false
    t.integer "phylum_id",       limit: 2, null: false
    t.integer "class_id",        limit: 2, null: false
    t.integer "orderx_id",       limit: 2, null: false
    t.integer "family_id",       limit: 2, null: false
    t.integer "genus_id",        limit: 2, null: false
    t.integer "species_id",      limit: 2, null: false
    t.integer "strain_id",       limit: 2, null: false
    t.integer "rank_id",         limit: 1, null: false
    t.string  "classifier",      limit: 4
  end

  add_index "taxonomies", ["class_id"], name: "class_id", using: :btree
  add_index "taxonomies", ["family_id"], name: "family_id", using: :btree
  add_index "taxonomies", ["genus_id"], name: "genus_id", using: :btree
  add_index "taxonomies", ["orderx_id"], name: "orderx_id", using: :btree
  add_index "taxonomies", ["phylum_id"], name: "phylum_id", using: :btree
  add_index "taxonomies", ["rank_id"], name: "rank_id", using: :btree
  add_index "taxonomies", ["species_id"], name: "species_id", using: :btree
  add_index "taxonomies", ["strain_id"], name: "strain_id", using: :btree
  add_index "taxonomies", ["superkingdom_id"], name: "superkingdom_id", using: :btree
  add_index "taxonomies", ["taxon_string_id", "superkingdom_id", "phylum_id", "class_id", "orderx_id", "family_id", "genus_id", "species_id", "strain_id", "rank_id", "classifier"], name: "all_unique", unique: true, using: :btree
  add_index "taxonomies", ["taxon_string_id"], name: "taxon_string_id", using: :btree

  create_table "user_contacts", primary_key: "user_contact_id", force: true do |t|
    t.integer "contact_id", limit: 2, default: 0, null: false
    t.integer "user_id",              default: 0, null: false
  end

  add_index "user_contacts", ["contact_id", "user_id"], name: "contact_id_user_id", unique: true, using: :btree
  add_index "user_contacts", ["user_id"], name: "user_id", using: :btree

  create_table "users", primary_key: "user_id", force: true do |t|
    t.string   "user",                   limit: 20,  default: "", null: false
    t.string   "email"
    t.string   "encrypted_password",     limit: 100, default: "", null: false
    t.string   "reset_password_token",   limit: 50
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 50
    t.string   "last_sign_in_ip",        limit: 50
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "active",                 limit: 1,   default: 0,  null: false
    t.integer  "security_level",         limit: 1,   default: 50, null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["user"], name: "USER", unique: true, using: :btree
  add_index "users", ["user"], name: "index_users_on_user", unique: true, using: :btree

  create_table "users_orig", primary_key: "user_id", force: true do |t|
    t.string  "user",           limit: 20, default: "", null: false
    t.string  "passwd",         limit: 50,              null: false
    t.integer "active",         limit: 1,  default: 0,  null: false
    t.integer "security_level", limit: 1,  default: 50, null: false
  end

  add_index "users_orig", ["user"], name: "USER", unique: true, using: :btree

end
