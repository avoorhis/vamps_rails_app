class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :project, {:limit => 32, :null => false, :default => ''}
      t.string :title, {:limit => 64, :null => false, :default => ''}
      t.string :project_description, {:limit => 255, :null => false, :default => ''}
      t.string :rev_project_name, {:limit => 32, :null => false, :default => ''}
      t.string :funding, {:limit => 64, :null => false, :default => ''}
      t.integer :contact_id
    end
    add_index :projects, :project, {:name => "project", :unique => true}
    add_index :projects, :rev_project_name, {:name => "rev_project_name", :unique => true}
    add_index :projects, :contact_id, {:name => "contact_id"}
  end
end
