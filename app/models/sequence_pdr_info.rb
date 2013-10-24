class SequencePdrInfo < ActiveRecord::Base
  belongs_to :sequence
  belongs_to :dataset

  has_many :projects,           :through => :dataset
  has_one  :sequence_uniq_info, :through => :sequence
  # has_one  :sequence_uniq_info, -> {select("sequence_uniq_infos.taxonomy_id").uniq }, :through => :sequence
  
  validates :seq_count, numericality: { only_integer: true }
  validates :classifier, :inclusion => { :in => ['RDP', 'GAST'] }
  
  # has_one  :sequence_uniq_info, -> {select("sequence_uniq_info.taxonomy_id") }, :through => :sequence
  
  # scope :taxonomy_ids, -> {joins(:sequence).where("sequence.sequence_id = 1000")}
  scope :taxonomy_ids, -> {includes(:sequence_uniq_info).select("sequence_uniq_infos.taxonomy_id").references(:sequence_uniq_infos) }
  
  
end
