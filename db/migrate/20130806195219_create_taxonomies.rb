class CreateTaxonomies < ActiveRecord::Migration
  def change
    create_table :taxonomies do |t|
      t.string :taxonomy, :limit => 300
      t.index  :taxonomy, {:name => "taxonomy", :unique => true}

      t.timestamps
    end
  end
end
