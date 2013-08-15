class Dataset < ActiveRecord::Base
  belongs_to :project
  belongs_to :user #TODO: How?
  belongs_to :env_sample_source

  has_many  :run_infos

  validates :dataset, :dataset_description, :presence => true, :format => /[A-Za-z1-9 ,]/
  validates :dataset, :dataset, :presence => true, :format => /[A-Za-z1-9_]/
  validates :project_id, :presence => true
  validates_uniqueness_of :project_id, :scope => :dataset

end
