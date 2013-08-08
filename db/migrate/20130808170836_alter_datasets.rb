class AlterDatasets < ActiveRecord::Migration
  # add comments and foreign keys
  def self.up
    execute "ALTER TABLE datasets CHANGE reads_in_dataset `reads_in_dataset` mediumint(6) unsigned NOT NULL DEFAULT '0' COMMENT 'number of reads in the dataset, old dataset_count'"
    execute "ALTER TABLE datasets CHANGE has_sequence `has_sequence` char(1) NOT NULL DEFAULT '0' COMMENT 'whether the dataset has sequence information for taxonomic counts, fasta, or clusters'"
    execute "ALTER TABLE datasets
      ADD CONSTRAINT dataset_fk_project_id FOREIGN KEY (project_id) REFERENCES projects (id) ON UPDATE CASCADE"
    execute "ALTER TABLE datasets
      ADD CONSTRAINT dataset_fk_env_sample_source_id FOREIGN KEY (env_sample_source_id) REFERENCES env_sample_sources (id) ON UPDATE CASCADE"

  end

  # no need to remove comments
  def self.down
    execute "ALTER TABLE datasets DROP FOREIGN KEY dataset_fk_project_id"
    execute "ALTER TABLE datasets DROP FOREIGN KEY dataset_fk_env_sample_source_id"
  end
end
