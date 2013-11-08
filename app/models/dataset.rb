class Dataset < ActiveRecord::Base
  belongs_to :project, touch: true
  belongs_to :env_sample_source, touch: true

  has_many   :sequence_pdr_infos
  has_many   :sequences, :through => :sequence_pdr_infos

  validates :dataset, :dataset_description, :presence => true, :format => /\A[\w ,.]+\z/
  validates :dataset, :dataset, :presence => true, :format => /\A\w+\z/
  validates :project_id, :presence => true, :format => /\A\d+\z/
  validates_uniqueness_of :project_id, :scope => :dataset

end
