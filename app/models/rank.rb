class Rank < ActiveRecord::Base
  has_many :sequence_uniq_infos
  
  # TODO: Do we need all of them?
  validates :rank, inclusion: { in: ["NA", "class", "domain", "family", "genus", "order", "orderx", "phylum", "species", "strain", "superkingdom"], message: "%{value} is not a valid rank" }, uniqueness: true
  
end
