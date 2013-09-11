class CreateSequencePdrInfos < ActiveRecord::Migration
  def change
    create_table :sequence_pdr_infos do |t|
  
      t.integer :sequence_id, :null => false
      t.column :seq_count, 'int unsigned', :null => false, :default => '0'

      t.timestamps
      
      
    end
  end
end
