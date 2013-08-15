class SequencePdrInfo < ActiveRecord::Base
  belongs_to :sequence
  belongs_to :run_info
  
  validates :seq_count, numericality: { only_integer: true }
  validates_uniqueness_of :run_info_id, :scope => :sequence_id
  
end
