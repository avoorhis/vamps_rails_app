class CreateRuns < ActiveRecord::Migration
  def change
    create_table :runs do |t|
      t.string :run, :limit => 16, :null => false, :default => ''
      t.column :run_prefix, "char(7)", :null => false, :default => ''
      t.date :date_trimmed, :comment => 'date that the raw sequence was trimmed and inserted.' #comment doesn't work
      
      t.index :run, {:name => "run", :unique => true}
    end
  end
end
