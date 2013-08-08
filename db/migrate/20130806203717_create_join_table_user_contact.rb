class CreateJoinTableUserContact < ActiveRecord::Migration
  def change
    create_join_table :contacts, :users do |t|
      t.index [:contact_id, :user_id], {:name => "contact_id_user_id", :unique => true}
      # t.index [:user_id, :contact_id]
      t.index  :user_id, {:name => "user_id"}
    end
  end
end
