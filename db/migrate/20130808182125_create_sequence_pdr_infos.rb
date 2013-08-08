class CreateSequencePdrInfos < ActiveRecord::Migration
  def change
    create_table :sequence_pdr_infos do |t|
      t.integer :run_info_id, :null => false
      t.integer :sequence_id, :null => false
      t.column :seq_count, 'int unsigned', :null => false, :default => '0'

      t.timestamps
      t.index [:run_info_id, :sequence_id], {:name => "uniq_seq_pdr", :unique => true}
      
    end
  end
end
