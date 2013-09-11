class AddForeignKeyTaxon < ActiveRecord::Migration
  def self.up
    execute "ALTER TABLE taxa
      ADD CONSTRAINT taxon_fk_rank_id FOREIGN KEY (rank_id) REFERENCES ranks (id) ON UPDATE CASCADE"
  end

  def self.down
    execute "ALTER TABLE taxa DROP FOREIGN KEY taxon_fk_rank_id"
  end
end
