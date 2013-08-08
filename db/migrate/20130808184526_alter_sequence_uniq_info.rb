class AlterSequenceUniqInfo < ActiveRecord::Migration
  def self.up
    execute "ALTER TABLE sequence_uniq_infos
          ADD CONSTRAINT sequence_uniq_info_fk_rank_id FOREIGN KEY (rank_id) REFERENCES ranks (id) ON UPDATE CASCADE"
    execute "ALTER TABLE sequence_uniq_infos
          ADD CONSTRAINT sequence_uniq_info_fk_sequence_id FOREIGN KEY (sequence_id) REFERENCES sequences (id) ON UPDATE CASCADE"
    execute "ALTER TABLE sequence_uniq_infos
          ADD CONSTRAINT sequence_uniq_info_fk_taxonomy_id FOREIGN KEY (taxonomy_id) REFERENCES taxonomies (id) ON UPDATE CASCADE"
  end

  # no need to remove comments
  def self.down
    execute "ALTER TABLE sequence_uniq_infos DROP FOREIGN KEY sequence_uniq_info_fk_rank_id"
    execute "ALTER TABLE sequence_uniq_infos DROP FOREIGN KEY sequence_uniq_info_fk_sequence_id"
    execute "ALTER TABLE sequence_uniq_infos DROP FOREIGN KEY sequence_uniq_info_fk_taxonomy_id"
  end
end
