class Project < ActiveRecord::Base
	belongs_to :user
	has_many :datasets

	validates :project, :title, :project_description, :presence => true, :format => /[A-Za-z1-9]/
	validates :user_id, :presence => true	
	
end
