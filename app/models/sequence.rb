class Sequence < ActiveRecord::Base
  has_many :sequence_uniq_infos
  has_many :sequence_pdr_infos
end
