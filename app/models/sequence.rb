class Sequence < ActiveRecord::Base
  has_many :sequence_uniq_infos
  has_many :sequence_pdr_infos
  
  validates :sequence_comp, uniqueness: true
  
end
