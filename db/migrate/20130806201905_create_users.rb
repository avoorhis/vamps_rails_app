class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username,    :limit => 20
      t.string :email,       :limit => 64, :null => false, :default => ""
      t.string :institution, :limit => 128
      t.string :first_name,  :limit => 20
      t.string :last_name,   :limit => 20
      t.column :active,         'tinyint unsigned', :null => false, :default => '0'
      t.column :security_level, 'tinyint unsigned', :null => false, :default => '50'
      
      t.index  :institution, {:length => 15, :name => "institution"}
      t.index  [:first_name, :last_name, :email, :institution], {:name => "contact_email_inst", :unique => true}      
      t.index  :username, {:name => "username", :unique => true}
      
    end
  end
end
