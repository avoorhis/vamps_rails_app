class Sequence < ActiveRecord::Base
  has_many :sequence_pdr_infos

  has_one :sequence_uniq_info
  has_one  :taxonomy, :through => :sequence_uniq_info
  
  validates :sequence_comp, uniqueness: true
  
end
