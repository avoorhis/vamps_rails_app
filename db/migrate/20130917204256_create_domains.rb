class CreateSuperkingdoms < ActiveRecord::Migration
  def change
    unless ActiveRecord::Base.connection.table_exists? 'superkingdoms'    
      create_table :superkingdoms do |t|
        t.string :superkingdom, {:limit => 300, :null => false, :default => ''}
        t.index  :superkingdom, {:name => "superkingdom", :unique => true}
      end    
    end
  end
end
