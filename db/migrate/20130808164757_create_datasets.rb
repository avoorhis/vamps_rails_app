class CreateDatasets < ActiveRecord::Migration
  def change
    create_table :datasets do |t|
      t.string :dataset, :limit => 64, :null => false, :default => ''
      t.string :dataset_description, :limit => 100, :null => false, :default => ''
      t.integer :env_sample_source_id
      t.integer :project_id
      
      t.index  [:dataset, :project_id], {:name => "dataset_project", :unique => true}
    end
  end
end
