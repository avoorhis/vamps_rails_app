class CreateDatasets < ActiveRecord::Migration
  def change
    create_table :datasets do |t|
      t.string :dataset, :limit => 64, :null => false, :default => ''
      t.string :dataset_description, :limit => 100, :null => false, :default => ''
      t.column :reads_in_dataset, 'mediumint unsigned', :null => false, :default => '0'
      t.column :has_sequence, "char(1)", :null => false, :default => ''
      t.integer :env_sample_source_id
      t.integer :project_id
      t.column :date_trimmed, "char(10)", :null => false, :default => ''
      
      t.index  [:dataset, :project_id], {:name => "dataset_project", :unique => true}
    end
  end
end
