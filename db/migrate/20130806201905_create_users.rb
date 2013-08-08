class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :user, :limit => 20
      t.string :passwd, :limit => 50
      t.column :active, 'tinyint unsigned', :null => false, :default => '0'
      t.column :security_level, 'tinyint unsigned', :null => false, :default => '50'
      
      t.index  :user, {:name => "user", :unique => true}
      
    end
  end
end
