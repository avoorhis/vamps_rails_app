class CreateAddForeignKeyUsersProjects < ActiveRecord::Migration
  def self.up
    execute "ALTER TABLE users_projects
      ADD CONSTRAINT users_projects_fk_project_id FOREIGN KEY (project_id) REFERENCES projects (id) ON UPDATE CASCADE"
    execute "ALTER TABLE users_projects
      ADD CONSTRAINT users_projects_fk_users_id FOREIGN KEY (user_id) REFERENCES users (id) ON UPDATE CASCADE"
  end

  def self.down
    execute "ALTER TABLE users_projects DROP FOREIGN KEY users_projects_fk_user_id"
    execute "ALTER TABLE users_projects DROP FOREIGN KEY users_projects_fk_project_id"
  end
end
