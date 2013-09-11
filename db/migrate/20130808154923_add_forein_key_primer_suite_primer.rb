class AddForeinKeyPrimerSuitePrimer < ActiveRecord::Migration
  def self.up
    execute "ALTER TABLE primer_suites_primers
      ADD CONSTRAINT primer_suites_primer_fk_primer_suite_id FOREIGN KEY (primer_suite_id) REFERENCES primer_suites (id) ON UPDATE CASCADE"
    execute "ALTER TABLE primer_suites_primers
          ADD CONSTRAINT primer_suites_primer_fk_primer_id FOREIGN KEY (primer_id) REFERENCES primers (id) ON UPDATE CASCADE"
  end

  def self.down
    execute "ALTER TABLE primer_suites_primers DROP FOREIGN KEY primer_suites_primer_fk_primer_suite_id"
    execute "ALTER TABLE primer_suites_primers DROP FOREIGN KEY primer_suites_primer_fk_primer_id"
  end
end
