class Rank < ActiveRecord::Base
  belongs_to :sequence_uniq_info
  
  # TODO: Do we need all of them?
  validates :rank, inclusion: { in: ["class", "domain", "family", "forma", "genus", "infraclass", "infraorder", "kingdom", "NA", "no rank", "order", "orderx", "parvorder", "phylum", "rank", "species", "species group", "species subgroup", "strain", "subclass", "subfamily", "subgenus", "subkingdom", "suborder", "subphylum", "subspecies", "subtribe", "superclass", "superfamily", "superkingdom", "superorder", "superphylum", "tribe", "varietas"],
      message: "%{value} is not a valid rank" }
  
end
