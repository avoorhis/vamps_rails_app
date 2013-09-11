class CreateSequencePdrInfos < ActiveRecord::Migration
  def change
    create_table :sequence_pdr_infos do |t|
  
      t.integer  "project_id",  null: false
      t.integer  "dataset_id",  null: false
      t.integer  "sequence_id", null: false
      t.integer  "seq_count",   null: false
      t.string   "classifier",  limit: 4, default: "GAST"

      t.timestamps
      
      
    end
    add_index "sequence_pdr_infos", ["project_id", "dataset_id", "sequence_id"], name: "uniq_seq_pd", unique: true, using: :btree
    add_index "sequence_pdr_infos", ["dataset_id"], name: "sequence_pdr_info_fk_dataset_id", using: :btree
    add_index "sequence_pdr_infos", ["sequence_id"], name: "sequence_pdr_info_fk_sequence_id", using: :btree
    
  end
end
