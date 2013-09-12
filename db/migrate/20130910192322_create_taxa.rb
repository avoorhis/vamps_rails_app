class CreateTaxa < ActiveRecord::Migration
  def change
    unless ActiveRecord::Base.connection.table_exists? 'taxa'    
      create_table :taxa do |t|
        t.string :taxon, {:limit => 300, :null => false, :default => ''}
        t.integer :rank_id, :null => false      
        t.index  :taxon, {:name => "taxon", :unique => true}
      end
    end
  end
end
