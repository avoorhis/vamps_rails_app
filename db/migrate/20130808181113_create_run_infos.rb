class CreateRunInfos < ActiveRecord::Migration
  def change
    create_table :run_infos do |t|
      t.integer :run_key_id, :null => false
      t.integer :run_id, :null => false
      t.column :lane, 'tinyint unsigned', :null => false, :default => '0'
      t.integer :dataset_id, :null => false
      t.integer :project_id, :null => false
      t.string :tubelabel, :limit => 32, :null => false, :default => ''
      t.column :barcode, "char(4)", :null => false, :default => ''
      t.column :adaptor, "char(3)", :null => false, :default => ''
      t.integer :dna_region_id, :null => false
      t.string :amp_operator, :limit => 5, :null => false, :default => ''
      t.string :seq_operator, :limit => 5, :null => false, :default => ''
      t.column :barcode_index, "char(12)", :null => false, :default => ''
      t.string :overlap
      t.column :insert_size, 'smallint unsigned', :null => false, :default => '0'
      t.column :read_length, 'smallint unsigned', :null => false, :default => '0'
      t.integer :primer_suite_id, :null => false
      t.timestamps

      t.index [:run_id, :run_key_id, :barcode_index, :lane], {:name => "uniq_key", :unique => true}

    end
  end
end
