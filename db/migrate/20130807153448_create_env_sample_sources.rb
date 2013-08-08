class CreateEnvSampleSources < ActiveRecord::Migration
  def change
    create_table :env_sample_sources do |t|
      t.string :env_source_name, :limit => 50
    end
    add_index :env_sample_sources, :env_source_name, {:unique => true, :name => "env_source_name"}
  end
end
