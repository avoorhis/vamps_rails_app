class Taxonomy < ActiveRecord::Base
  has_many :sequence_uniq_infos
	has_many :sequences, :through => :sequence_uniq_infos  
	has_many :ranks,     :through => :sequence_uniq_infos  
  # has_many :datasets,  :through => :sequence_uniq_infos, :source => :sequence_pdr_infos 
	
	belongs_to :domain      , touch: true
	belongs_to :phylum      , touch: true
	belongs_to :klass       #, touch: true
	belongs_to :order       , touch: true
	belongs_to :family      , touch: true
	belongs_to :genus       , touch: true
	belongs_to :species     , touch: true
	belongs_to :strain      , touch: true

  validates_uniqueness_of :domain_id, :scope => [:phylum_id, :klass_id, :order_id, :family_id, :genus_id, :species_id, :strain_id]
  
end
 
 
 
 
 
 
 
 