class SequenceUniqInfo < ActiveRecord::Base
  belongs_to :rank
  belongs_to :taxonomy
  belongs_to :sequence
  # refssu_id?
  
  has_one  :domain      , :through => :taxonomy
  has_one  :phylum      , :through => :taxonomy
  has_one  :klass       , :through => :taxonomy
  has_one  :order       , :through => :taxonomy
  has_one  :family      , :through => :taxonomy
  has_one  :genus       , :through => :taxonomy
  has_one  :species     , :through => :taxonomy
  has_one  :strain      , :through => :taxonomy 

  has_many :sequence_pdr_infos, :through => :sequence 
	
  attr_accessible :sequence_id, :taxonomy_id, :gast_distance, :refssu_id, :refssu_count, :rank_id, :refhvr_ids, :created_at, :updated_at
	
  validates :refssu_count,  numericality: { only_integer: true }
  validates :gast_distance, numericality: true
  validates_uniqueness_of :sequence_id
    
end
