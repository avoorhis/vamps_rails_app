class Project < ActiveRecord::Base
	belongs_to :contact
	has_many   :datasets
  has_many   :run_infos, :through => :datasets

	validates :project, :title, :project_description, :presence => true, :format => /[A-Za-z1-9]/
	validates :contact_id, :env_sample_source_id, :presence => true	
	validates :project, uniqueness: true
  validates :rev_project_name, uniqueness: true
  
end
