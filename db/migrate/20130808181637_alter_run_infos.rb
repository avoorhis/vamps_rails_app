class AlterRunInfos < ActiveRecord::Migration
  def self.up
    execute "ALTER TABLE run_infos CHANGE overlap overlap enum('complete','partial','none') NOT NULL DEFAULT 'none'"
    execute "ALTER TABLE run_infos CHANGE read_length read_length smallint(5) unsigned NOT NULL COMMENT 'the raw reads lengths from the machine'"
    
    execute "ALTER TABLE run_infos
          ADD CONSTRAINT run_info_fk_run_id FOREIGN KEY (run_id) REFERENCES runs (id) ON UPDATE CASCADE"
          
    execute "ALTER TABLE run_infos
          ADD CONSTRAINT run_info_fk_run_key_id FOREIGN KEY (run_key_id) REFERENCES run_keys (id) ON UPDATE CASCADE"

    execute "ALTER TABLE run_infos
          ADD CONSTRAINT run_info_fk_dna_region_id FOREIGN KEY (dna_region_id) REFERENCES dna_regions (id) ON UPDATE CASCADE"

    execute "ALTER TABLE run_infos
          ADD CONSTRAINT run_info_fk_project_id FOREIGN KEY (project_id) REFERENCES projects (id) ON UPDATE CASCADE"

    execute "ALTER TABLE run_infos
          ADD CONSTRAINT run_info_fk_dataset_id FOREIGN KEY (dataset_id) REFERENCES datasets (id) ON UPDATE CASCADE"

    execute "ALTER TABLE run_infos
          ADD CONSTRAINT run_info_fk_primer_suite_id FOREIGN KEY (primer_suite_id) REFERENCES primer_suites (id) ON UPDATE CASCADE"    
  end

  # no need to remove comments
  def self.down
    execute "ALTER TABLE run_infos CHANGE overlap overlap varchar(10)"
    execute "ALTER TABLE run_infos DROP FOREIGN KEY run_info_fk_run_id"
    execute "ALTER TABLE run_infos DROP FOREIGN KEY run_info_fk_run_key_id"
    execute "ALTER TABLE run_infos DROP FOREIGN KEY run_info_fk_dna_region_id"
    execute "ALTER TABLE run_infos DROP FOREIGN KEY run_info_fk_project_id"
    execute "ALTER TABLE run_infos DROP FOREIGN KEY run_info_fk_dataset_id"
    execute "ALTER TABLE run_infos DROP FOREIGN KEY run_info_fk_primer_suite_id"
  end
end
