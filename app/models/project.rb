class Project < ActiveRecord::Base
	belongs_to :users
	has_many   :datasets
  has_many   :run_infos, :through => :datasets

  validates :project, :title, :project_description, :presence => true, :format => /[A-Za-z1-9_]/
	validates :user_id, :presence => true	
	validates :project, uniqueness: true
  validates :rev_project_name, uniqueness: true
  
end
