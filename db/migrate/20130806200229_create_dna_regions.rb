class CreateDnaRegions < ActiveRecord::Migration
  def change
    create_table :dna_regions do |t|
      t.string :dna_region, :limit => 32
    end
    add_index :dna_regions, :dna_region, {:name => "dna_region", :unique => true}
  end
end
