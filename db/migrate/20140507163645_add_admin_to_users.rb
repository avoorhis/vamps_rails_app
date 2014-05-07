class AddAdminToUsers < ActiveRecord::Migration
  #  https://github.com/plataformatec/devise/wiki/How-To:-Add-an-Admin-role
  def self.up
    add_column :users, :admin, :boolean, :default => false
  end

  def self.down
    remove_column :users, :admin
  end
end