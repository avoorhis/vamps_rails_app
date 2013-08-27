class AddForeignKeyProjects < ActiveRecord::Migration
  def self.up
    execute "ALTER TABLE projects
      ADD CONSTRAINT project_fk_user_id FOREIGN KEY (user_id) REFERENCES users (id) ON UPDATE CASCADE"
  end

  def self.down
    execute "ALTER TABLE projects DROP FOREIGN KEY project_fk_user_id"
  end
  
end
