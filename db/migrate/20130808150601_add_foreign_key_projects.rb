class AddForeignKeyProjects < ActiveRecord::Migration
  def self.up
    execute "ALTER TABLE projects
      ADD CONSTRAINT project_fk_contact_id FOREIGN KEY (contact_id) REFERENCES contacts (id) ON UPDATE CASCADE"
  end

  def self.down
    execute "ALTER TABLE projects DROP FOREIGN KEY project_fk_contact_id"
  end
  
end
