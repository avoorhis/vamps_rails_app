class SequencePdrInfo < ActiveRecord::Base
  belongs_to :sequence
  belongs_to :dataset

  has_many :projects, :through => :dataset
  has_one  :sequence_uniq_infos, :through => :sequence
  # has_one :project, :through => :dataset
  # has_many   :run_infos, :through => :datasets
  
  validates :seq_count, numericality: { only_integer: true }
  
  
end
