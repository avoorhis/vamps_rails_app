class Taxonomy < ActiveRecord::Base
  has_many :sequence_uniq_infos
	has_many :sequences, :through => :sequence_uniq_infos  
	has_many :ranks,     :through => :sequence_uniq_infos  
	has_many :datasets,  :through => :sequence_uniq_infos, :source => :sequence_pdr_infos 
	
	has_one  :superkingdom
	has_one  :phylum      
	has_one  :klass       
	has_one  :order
	has_one  :family      
	has_one  :genus       
	has_one  :species     
	has_one  :strain      

  validates :taxonomy, uniqueness: true
end
 
 
 
 
 
 
 
 