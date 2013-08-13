class Sequence < ActiveRecord::Base
  has_many :sequence_uniq_info
  has_many :sequence_pdr_info
end
