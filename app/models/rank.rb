class Rank < ActiveRecord::Base
  has_many :sequence_uniq_infos
  has_many :taxa
  
  # TODO: Do we need all of them?
  validates :rank, inclusion: { in: ["NA", "class", "domain", "family", "genus", "orderx", "phylum", "species", "strain", "superkingdom"], message: "%{value} is not a valid rank" }, uniqueness: true
  scope :sorted, order(:rank_number)
  
end
