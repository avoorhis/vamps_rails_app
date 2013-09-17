class CreateTaxonomies < ActiveRecord::Migration
  def change
    create_table "taxonomies", force: true do |t|
      t.integer  "superkingdom_id"
      t.integer  "phylum_id"
      t.integer  "klass_id"
      t.integer  "order_id"
      t.integer  "family_id"
      t.integer  "genus_id"
      t.integer  "species_id"
      t.integer  "strain_id"
      t.timestamps
    end

    add_index "taxonomies", ["superkingdom_id", "phylum_id", "klass_id", "order_id", "family_id", "genus_id", "species_id", "strain_id"], name: "all_names", unique: true    
  end
end
