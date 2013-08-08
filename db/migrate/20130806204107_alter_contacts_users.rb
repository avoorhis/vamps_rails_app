#encoding: utf-8
class AlterContactsUsers < ActiveRecord::Migration
# run after filling data in
  def self.up
    execute "ALTER TABLE contacts_users ADD CONSTRAINT contacts_users_fk_contact_id FOREIGN KEY (contact_id) references contacts (id);"
    execute "ALTER TABLE contacts_users ADD CONSTRAINT contacts_users_fk_user_id FOREIGN KEY (user_id) references users (id);"
  end

  def self.down
    execute "ALTER TABLE contacts_users DROP FOREIGN KEY contacts_users_fk_contact_id"
    execute "ALTER TABLE contacts_users DROP FOREIGN KEY contacts_users_fk_user_id"
  end
  
end
