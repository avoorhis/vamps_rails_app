class CreatePhylums < ActiveRecord::Migration
  def change
    unless ActiveRecord::Base.connection.table_exists? 'phylums'    
      create_table :phylums do |t|
        t.string :phylum, {:limit => 300, :null => false, :default => ''}
        t.index  :phylum, {:name => "phylum", :unique => true}
      end
    end
  end
end
