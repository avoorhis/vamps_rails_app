class CreateKlasses < ActiveRecord::Migration
  def change
    unless ActiveRecord::Base.connection.table_exists? 'klasses'    
      create_table :klasses do |t|
        t.string :klass, {:limit => 300, :null => false, :default => ''}
        t.index  :klass, {:name => "klass", :unique => true}
      end
    end
  end
end
