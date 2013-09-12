class CreateTaxonomies < ActiveRecord::Migration
  def change
    create_table "taxonomies", force: true do |t|
      t.integer  "superkingdom_id"
      t.integer  "phylum_id"
      t.integer  "class_id"
      t.integer  "orderx_id"
      t.integer  "family_id"
      t.integer  "genus_id"
      t.integer  "species_id"
      t.integer  "strain_id"
      t.timestamps
    end

    add_index "taxonomies", ["class_id"], name: "taxonomy_fk_taxa_id3"
    add_index "taxonomies", ["family_id"], name: "taxonomy_fk_taxa_id5"
    add_index "taxonomies", ["genus_id"], name: "taxonomy_fk_taxa_id6"
    add_index "taxonomies", ["orderx_id"], name: "taxonomy_fk_taxa_id4"
    add_index "taxonomies", ["phylum_id"], name: "taxonomy_fk_taxa_id2"
    add_index "taxonomies", ["species_id"], name: "taxonomy_fk_taxa_id7"
    add_index "taxonomies", ["strain_id"], name: "taxonomy_fk_taxa_id8"
    add_index "taxonomies", ["superkingdom_id", "phylum_id", "class_id", "orderx_id", "family_id", "genus_id", "species_id", "strain_id"], name: "all_names", unique: true    
  end
end
