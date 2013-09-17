class CreateGenera < ActiveRecord::Migration
  def change
    unless ActiveRecord::Base.connection.table_exists? 'genera'    
      create_table :genera do |t|
        t.string :genus, {:limit => 300, :null => false, :default => ''}
        t.index  :genus, {:name => "genus", :unique => true}
      end
    end
  end
end
