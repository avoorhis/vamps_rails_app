class AlterSequencePdrInfo < ActiveRecord::Migration
  def self.up
    execute "ALTER TABLE sequence_pdr_infos COMMENT = 'sequences uniqued per project / dataset'"
    execute "ALTER TABLE sequence_pdr_infos CHANGE seq_count seq_count int(11) unsigned NOT NULL COMMENT 'count unique sequence per run / project / dataset = frequency from a file'"
    
    execute "ALTER TABLE sequence_pdr_infos
          ADD CONSTRAINT sequence_pdr_info_fk_sequence_id FOREIGN KEY (sequence_id) REFERENCES sequences (id) ON UPDATE CASCADE"
          
    
  end

  # no need to remove comments
  def self.down
    execute "ALTER TABLE sequence_pdr_infos DROP FOREIGN KEY sequence_pdr_info_fk_sequence_id"
    
  end
end
