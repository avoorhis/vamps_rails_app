class SequenceUniqInfo < ActiveRecord::Base
  belongs_to :rank
  belongs_to :taxonomy
  belongs_to :sequence
  # refssu_id?
  
  validates :refssu_count,  numericality: { only_integer: true }
  validates :gast_distance, numericality: true
  validates_uniqueness_of :sequence_id
  
end
