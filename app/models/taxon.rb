class Taxon < ActiveRecord::Base
  has_one  :rank
  has_many :taxonomies
  
end
