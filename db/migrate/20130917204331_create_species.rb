class CreateSpecies < ActiveRecord::Migration
  def change
    unless ActiveRecord::Base.connection.table_exists? 'species'    
      create_table :species do |t|
        t.string :species, {:limit => 255, :null => false, :default => ''}
        t.index  :species, {:name => "species", :unique => true}
      end
    end
  end
end
