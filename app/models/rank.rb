class Rank < ActiveRecord::Base
  has_many :sequence_uniq_infos
  has_many :taxa
  
  # TODO: Do we need all of them?
  validates :rank, inclusion: { in: ["NA", "class", "domain", "family", "genus", "order", "phylum", "species", "strain"], message: "%{value} is not a valid rank" }, uniqueness: true
  scope :sorted, -> { order(:rank_number) }    

# It's better to use a rails object: Rank.find(rank_id).rank_number
# def get_rank_number(n)
#   return :rank_number
# end
end
