class CreateRunKeys < ActiveRecord::Migration
  def change
    create_table :run_keys do |t|
      t.string :run_key, :limit => 25, :null => false, :default => ''
    end
    add_index :run_keys, :run_key, {:name => "run_key", :unique => true}
  end
end
