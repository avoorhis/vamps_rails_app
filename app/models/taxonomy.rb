class Taxonomy < ActiveRecord::Base
  has_many  :sequence_uniq_infos
	has_many  :sequences, :through => :sequence_uniq_infos  
	has_many  :ranks,     :through => :sequence_uniq_infos  

  validates :taxonomy, uniqueness: true
end
