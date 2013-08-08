class CreateRanks < ActiveRecord::Migration
  def change
    create_table :ranks do |t|
      t.string :rank, {:limit => 32, :null => false, :default => ''}
    end
    add_index :ranks, :rank, {:name => "rank", :unique => true}
  end
end
