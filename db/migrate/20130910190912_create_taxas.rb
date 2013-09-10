class CreateTaxa < ActiveRecord::Migration
  def change
    create_table :taxas do |t|
      t.string :taxon, {:limit => 300, :null => false, :default => ''}
      t.integer :rank_id, :null => false      
      t.index  :rank, {:name => "rank", :unique => true}
    end
  end
end
