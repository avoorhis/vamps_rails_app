class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :contact, :limit => 32
      t.string :email, :limit => 64
      t.string :institution, :limit => 128
      t.string :vamps_name, :limit => 20
      t.string :first_name, :limit => 20
      t.string :last_name, :limit => 20
      t.index  :institution, {:length => 15, :name => "institution"}
      t.index  [:contact, :email, :institution], {:name => "contact_email_inst", :unique => true}

      t.timestamps
    end
  end
end
