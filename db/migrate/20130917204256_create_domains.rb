class CreateDomains < ActiveRecord::Migration
  def change
    unless ActiveRecord::Base.connection.table_exists? 'domains'    
      create_table :domains do |t|
        t.string :domain, {:limit => 300, :null => false, :default => ''}
        t.index  :domain, {:name => "domain", :unique => true}
      end    
    end
  end
end
