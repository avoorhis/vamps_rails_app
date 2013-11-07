class Dataset < ActiveRecord::Base
  belongs_to :project
  belongs_to :env_sample_source

  has_many   :sequence_pdr_infos
  has_many   :sequences, :through => :sequence_pdr_infos

  validates :dataset, :dataset_description, :presence => true, :format => /\A[\w ,.]+\z/
  validates :dataset, :dataset, :presence => true, :format => /\A\w+\z/
  validates :project_id, :presence => true, :format => /\d+/
  validates_uniqueness_of :project_id, :scope => :dataset

end
