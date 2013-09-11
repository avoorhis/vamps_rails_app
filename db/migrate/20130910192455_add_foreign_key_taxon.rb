class AddForeignKeyTaxon < ActiveRecord::Migration
  def self.up
    unless ActiveRecord::Base.connection.index_name_exists?('taxa', 'taxon_fk_rank_id', false)    
      execute "ALTER TABLE taxa
        ADD CONSTRAINT taxon_fk_rank_id FOREIGN KEY (rank_id) REFERENCES ranks (id) ON UPDATE CASCADE"
    end
  end

  def self.down
    execute "ALTER TABLE taxa DROP FOREIGN KEY taxon_fk_rank_id"
  end
end
