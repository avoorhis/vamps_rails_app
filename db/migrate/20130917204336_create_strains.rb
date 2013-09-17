class CreateStrains < ActiveRecord::Migration
  def change
    unless ActiveRecord::Base.connection.table_exists? 'strains'    
      create_table :strains do |t|
        t.string :strain, {:limit => 300, :null => false, :default => ''}
        t.index  :strain, {:name => "strain", :unique => true}
      end
    end
  end
end
