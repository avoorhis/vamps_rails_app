class CreatePrimers < ActiveRecord::Migration
  def change
    create_table :primers do |t|
      t.string :primer, :limit => 16
      t.string :direction, :limit => 2
      t.string :sequence, :limit => 64
      t.string :region, :limit => 16
      t.string :original_seq, :limit => 64
      t.string :domain, :limit => 10
    end
    add_index :primers, :primer, {:unique => true, :name => "primer"}    
  end
end
