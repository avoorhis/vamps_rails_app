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

ActiveRecord::Schema.define(version: 20130914150755) do

  create_table "datasets", force: true do |t|
    t.string  "dataset",              limit: 64,  default: "", null: false
    t.string  "dataset_description",  limit: 100, default: "", null: false
    t.integer "env_sample_source_id"
    t.integer "project_id"
  end

  add_index "datasets", ["dataset", "project_id"], name: "dataset_project", unique: true, using: :btree
  add_index "datasets", ["env_sample_source_id"], name: "dataset_fk_env_sample_source_id", using: :btree
  add_index "datasets", ["project_id"], name: "dataset_fk_project_id", using: :btree

  create_table "dna_regions", force: true do |t|
    t.string "dna_region", limit: 32
  end

  add_index "dna_regions", ["dna_region"], name: "dna_region", unique: true, using: :btree

  create_table "env_sample_sources", force: true do |t|
    t.integer "env_sample_source_id", limit: 2,  default: 0, null: false
    t.string  "env_source_name",      limit: 50
  end

  add_index "env_sample_sources", ["env_source_name"], name: "env_source_name", unique: true, using: :btree

  create_table "ill_full_temp", id: false, force: true do |t|
    t.integer "run_info_run_info_id",                                                                default: 0,      null: false
    t.integer "run_info_run_key_id",                                                                                  null: false
    t.integer "run_info_run_id",                                                                                      null: false
    t.integer "run_info_lane",                            limit: 1,                                  default: 0,      null: false
    t.integer "run_info_dataset_id",                                                                                  null: false
    t.integer "run_info_project_id",                                                                                  null: false
    t.string  "run_info_tubelabel",                       limit: 32,                                 default: "",     null: false
    t.string  "run_info_barcode",                         limit: 4,                                  default: "",     null: false
    t.string  "run_info_adaptor",                         limit: 3,                                  default: "",     null: false
    t.integer "run_info_dna_region_id",                                                                               null: false
    t.string  "run_info_amp_operator",                    limit: 5,                                  default: "",     null: false
    t.string  "run_info_seq_operator",                    limit: 5,                                  default: "",     null: false
    t.string  "run_info_barcode_index",                   limit: 12,                                 default: "",     null: false
    t.string  "run_info_overlap",                         limit: 8,                                  default: "none", null: false
    t.integer "run_info_insert_size",                     limit: 2,                                  default: 0,      null: false
    t.string  "run_info_file_prefix",                     limit: 0,                                  default: "",     null: false
    t.integer "run_info_read_length",                     limit: 2,                                                   null: false
    t.integer "run_info_primer_suite_id",                                                                             null: false
    t.integer "run_key_run_key_id",                                                                  default: 0,      null: false
    t.string  "run_key",                                  limit: 25,                                 default: "",     null: false
    t.integer "run_run_id",                                                                          default: 0,      null: false
    t.string  "run_run",                                  limit: 16,                                 default: "",     null: false
    t.string  "run_run_prefix",                           limit: 7,                                  default: "",     null: false
    t.date    "run_date_trimmed"
    t.integer "dna_region_dna_region_id",                                                            default: 0,      null: false
    t.string  "dna_region_dna_region",                    limit: 32
    t.integer "primer_suite_primer_suite_id",                                                        default: 0,      null: false
    t.string  "primer_suite_primer_suite",                limit: 25,                                 default: "",     null: false
    t.integer "sequence_pdr_info_sequence_pdr_info_id",                                              default: 0,      null: false
    t.integer "sequence_pdr_info_run_info_id",                                                                        null: false
    t.integer "sequence_pdr_info_sequence_id",                                                                        null: false
    t.integer "sequence_pdr_info_seq_count",                                                                          null: false
    t.integer "sequence_uniq_info_sequence_uniq_info_id",                                            default: 0,      null: false
    t.integer "sequence_uniq_info_sequence_id",                                                                       null: false
    t.integer "sequence_uniq_info_taxonomy_id",                                                                       null: false
    t.decimal "sequence_uniq_info_gast_distance",                            precision: 7, scale: 5,                  null: false
    t.integer "sequence_uniq_info_refssu_id",                                                                         null: false
    t.integer "sequence_uniq_info_refssu_count",                                                     default: 0,      null: false
    t.integer "sequence_uniq_info_rank_id",                                                                           null: false
    t.text    "sequence_uniq_info_refhvr_ids",                                                                        null: false
    t.integer "rank_rank_id",                                                                        default: 0,      null: false
    t.string  "rank_rank",                                limit: 32,                                 default: "",     null: false
    t.string  "taxonomy",                                 limit: 300
    t.integer "sequence_sequence_id",                                                                default: 0,      null: false
    t.binary  "sequence",                                 limit: 2147483647,                                          null: false
    t.integer "project_project_id",                                                                  default: 0,      null: false
    t.string  "project_project",                          limit: 32,                                 default: "",     null: false
    t.string  "project_title",                            limit: 64,                                 default: "",     null: false
    t.string  "project_project_description",                                                         default: "",     null: false
    t.string  "project_rev_project_name",                 limit: 32,                                 default: "",     null: false
    t.string  "project_funding",                          limit: 64,                                 default: "",     null: false
    t.integer "env_sample_source_id"
    t.integer "project_contact_id"
    t.integer "env_sample_source_env_sample_source_id",                                              default: 0,      null: false
    t.string  "env_sample_source_env_source_name",        limit: 50
    t.integer "contact_contact_id",                                                                  default: 0,      null: false
    t.string  "contact_contact",                          limit: 32
    t.string  "contact_email",                            limit: 64
    t.string  "contact_institution",                      limit: 128
    t.string  "contact_vamps_name",                       limit: 20
    t.string  "contact_first_name",                       limit: 20
    t.string  "contact_last_name",                        limit: 20
    t.integer "dataset_dataset_id",                                                                  default: 0,      null: false
    t.string  "dataset_dataset",                          limit: 64,                                 default: "",     null: false
    t.string  "dataset_dataset_description",              limit: 100,                                default: "",     null: false
  end

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
    t.integer "rank_number", limit: 1,  default: 0,  null: false
  end

  add_index "ranks", ["rank"], name: "rank", unique: true, using: :btree

  create_table "sequence_pdr_infos", force: true do |t|
    t.integer  "project_id",                             null: false
    t.integer  "dataset_id",                             null: false
    t.integer  "sequence_id",                            null: false
    t.integer  "seq_count",                              null: false
    t.string   "classifier",  limit: 4, default: "GAST"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sequence_pdr_infos", ["dataset_id"], name: "sequence_pdr_info_fk_dataset_id", using: :btree
  add_index "sequence_pdr_infos", ["project_id", "dataset_id", "sequence_id"], name: "uniq_seq_pd", unique: true, using: :btree
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

  create_table "taxa", force: true do |t|
    t.string  "taxon",   limit: 300
    t.integer "rank_id",             null: false
  end

  add_index "taxa", ["rank_id"], name: "taxon_fk_rank_id", using: :btree
  add_index "taxa", ["taxon"], name: "taxon", unique: true, using: :btree

  create_table "taxonomies", force: true do |t|
    t.integer  "superkingdom_id"
    t.integer  "phylum_id"
    t.integer  "class_id"
    t.integer  "orderx_id"
    t.integer  "family_id"
    t.integer  "genus_id"
    t.integer  "species_id"
    t.integer  "strain_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "taxonomies", ["class_id"], name: "taxonomy_fk_taxa_id3", using: :btree
  add_index "taxonomies", ["family_id"], name: "taxonomy_fk_taxa_id5", using: :btree
  add_index "taxonomies", ["genus_id"], name: "taxonomy_fk_taxa_id6", using: :btree
  add_index "taxonomies", ["orderx_id"], name: "taxonomy_fk_taxa_id4", using: :btree
  add_index "taxonomies", ["phylum_id"], name: "taxonomy_fk_taxa_id2", using: :btree
  add_index "taxonomies", ["species_id"], name: "taxonomy_fk_taxa_id7", using: :btree
  add_index "taxonomies", ["strain_id"], name: "taxonomy_fk_taxa_id8", using: :btree
  add_index "taxonomies", ["superkingdom_id", "phylum_id", "class_id", "orderx_id", "family_id", "genus_id", "species_id", "strain_id"], name: "all_names", unique: true, using: :btree

  create_table "taxonomies_old", force: true do |t|
    t.string   "taxonomy",   limit: 300
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "taxonomies_old", ["taxonomy"], name: "taxonomy", unique: true, using: :btree

  create_table "taxonomies_sep", force: true do |t|
    t.string   "superkingdom",    limit: 60, default: "", null: false
    t.integer  "superkingdom_id"
    t.string   "phylum",          limit: 60, default: "", null: false
    t.integer  "phylum_id"
    t.string   "class",           limit: 60, default: "", null: false
    t.integer  "class_id"
    t.string   "orderx",          limit: 60, default: "", null: false
    t.integer  "orderx_id"
    t.string   "family",          limit: 60, default: "", null: false
    t.integer  "family_id"
    t.string   "genus",           limit: 60, default: "", null: false
    t.integer  "genus_id"
    t.string   "species",         limit: 60, default: "", null: false
    t.integer  "species_id"
    t.string   "strain",          limit: 60, default: "", null: false
    t.integer  "strain_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "taxonomies_sep", ["superkingdom", "phylum", "class", "orderx", "family", "genus", "species", "strain"], name: "all_names", unique: true, using: :btree

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

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["first_name", "last_name", "email", "institution"], name: "contact_email_inst", unique: true, using: :btree
  add_index "users", ["institution"], name: "institution", length: {"institution"=>15}, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["username"], name: "username", unique: true, using: :btree

end
