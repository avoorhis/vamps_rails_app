class AlterPrimers < ActiveRecord::Migration
  # Change to enum and add comments
  def self.up
    execute "ALTER TABLE primers CHANGE primer primer varchar(16) NOT NULL DEFAULT '' COMMENT 'name of the sequencing primer'"
    execute "ALTER TABLE primers CHANGE direction direction enum('F','R') NOT NULL COMMENT 'direction of priming, forward or reverse'"
    execute "ALTER TABLE primers CHANGE sequence sequence varchar(64) NOT NULL DEFAULT '' COMMENT 'primer sequence -- includes regular expressions for multiple bases or fuzzy matching'"
    execute "ALTER TABLE primers CHANGE region region varchar(16) NOT NULL DEFAULT '' COMMENT 'region of the genome being amplified'"
    execute "ALTER TABLE primers CHANGE original_seq original_seq varchar(64) NOT NULL DEFAULT '' COMMENT 'primer sequence as ordered from the primer supply company'"
    execute "ALTER TABLE primers CHANGE domain domain enum('bacteria','archaea','eukarya','') DEFAULT NULL"
  end

  # no need to remove comments
  def self.down
    execute "ALTER TABLE primers CHANGE direction direction varchar(2)"
    execute "ALTER TABLE primers CHANGE domain domain varchar(10)"
  end
end
