class Taxonomy < ActiveRecord::Base
  has_many :sequence_uniq_infos
	has_many :sequences, :through => :sequence_uniq_infos  
	has_many :ranks,     :through => :sequence_uniq_infos  
  # has_many :datasets,  :through => :sequence_uniq_infos, :source => :sequence_pdr_infos 
	
	belongs_to :domain 
	belongs_to :phylum 
	belongs_to :klass  
	belongs_to :order  
	belongs_to :family 
	belongs_to :genus  
	belongs_to :species
	belongs_to :strain 

  validates_uniqueness_of :domain_id, :scope => [:phylum_id, :klass_id, :order_id, :family_id, :genus_id, :species_id, :strain_id]
  
end
 
 
 
 
 
 
 
 