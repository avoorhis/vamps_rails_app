class SequencePdrInfo < ActiveRecord::Base
  belongs_to :sequence
  
  
  validates :seq_count, numericality: { only_integer: true }
  
  
end
