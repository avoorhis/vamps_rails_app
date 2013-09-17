class CreateFamilies < ActiveRecord::Migration
  def change
    unless ActiveRecord::Base.connection.table_exists? 'families'    
      create_table :families do |t|
        t.string :family, {:limit => 300, :null => false, :default => ''}
        t.index  :family, {:name => "family", :unique => true}
      end
    end
  end
end
