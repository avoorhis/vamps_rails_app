class CreateSequenceUniqInfos < ActiveRecord::Migration
  def change
    create_table :sequence_uniq_infos do |t|
      t.integer :sequence_id, :null => false
      t.integer :taxonomy_id, :null => false
      t.decimal :gast_distance, precision: 7, scale: 5, :null => false
      t.integer :refssu_id, :null => false
      t.column :refssu_count, 'int unsigned', :null => false, :default => '0'
      t.integer :rank_id, :null => false
      t.text :refhvr_ids, :null => false

      t.timestamps
      t.index :sequence_id, {:name => "sequence_id", :unique => true}
      t.index :refssu_id, {:name => "refssu_id"}
      
    end
  end
end
