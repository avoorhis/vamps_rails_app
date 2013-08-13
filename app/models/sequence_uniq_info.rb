class SequenceUniqInfo < ActiveRecord::Base
  belongs_to :rank
  belongs_to :taxonomy
  belongs_to :sequence
  # refssu_id?
  
  validates :refssu_count,  numericality: { only_integer: true }
  validates :gast_distance, numericality: true
  
end
