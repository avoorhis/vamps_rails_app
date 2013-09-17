class AddForeignKeyTaxonomies < ActiveRecord::Migration
  def self.up
    execute "ALTER TABLE `taxonomies`
      ADD CONSTRAINT `taxonomy_fk_superkingdom_id` FOREIGN KEY (`superkingdom_id`) REFERENCES `superkingdoms` (`id`) ON UPDATE CASCADE"
    execute "ALTER TABLE `taxonomies`
      ADD CONSTRAINT `taxonomy_fk_phylum_id` FOREIGN KEY (`phylum_id`) REFERENCES `phylums` (`id`) ON UPDATE CASCADE"
    execute "ALTER TABLE `taxonomies`
      ADD CONSTRAINT `taxonomy_fk_class_id` FOREIGN KEY (`class_id`) REFERENCES `klasses` (`id`) ON UPDATE CASCADE"
    execute "ALTER TABLE `taxonomies`
      ADD CONSTRAINT `taxonomy_fk_order_id` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON UPDATE CASCADE"
    execute "ALTER TABLE `taxonomies`
      ADD CONSTRAINT `taxonomy_fk_family_id` FOREIGN KEY (`family_id`) REFERENCES `families` (`id`) ON UPDATE CASCADE"
    execute "ALTER TABLE `taxonomies`
      ADD CONSTRAINT `taxonomy_fk_genus_id` FOREIGN KEY (`genus_id`) REFERENCES `genera` (`id`) ON UPDATE CASCADE"
    execute "ALTER TABLE `taxonomies`
      ADD CONSTRAINT `taxonomy_fk_species_id` FOREIGN KEY (`species_id`) REFERENCES `species` (`id`) ON UPDATE CASCADE"
    execute "ALTER TABLE `taxonomies`
      ADD CONSTRAINT `taxonomy_fk_strain_id` FOREIGN KEY (`strain_id`) REFERENCES `strains` (`id`) ON UPDATE CASCADE"     
  end

  def self.down
    execute "ALTER TABLE taxonomies DROP FOREIGN KEY taxonomy_fk_superkingdom_id"
    execute "ALTER TABLE taxonomies DROP FOREIGN KEY taxonomy_fk_phylum_id"
    execute "ALTER TABLE taxonomies DROP FOREIGN KEY taxonomy_fk_klass_id"
    execute "ALTER TABLE taxonomies DROP FOREIGN KEY taxonomy_fk_order_id"
    execute "ALTER TABLE taxonomies DROP FOREIGN KEY taxonomy_fk_family_id"
    execute "ALTER TABLE taxonomies DROP FOREIGN KEY taxonomy_fk_genus_id"
    execute "ALTER TABLE taxonomies DROP FOREIGN KEY taxonomy_fk_species_id"
    execute "ALTER TABLE taxonomies DROP FOREIGN KEY taxonomy_fk_strain_id"
  end
end
