class Project < ActiveRecord::Base
	belongs_to :user
	has_many   :datasets
  has_many   :sequence_pdr_infos, :through => :datasets

  accepts_nested_attributes_for :datasets

  validates :project, :presence => true, uniqueness: true, :format => /\A\w+\z/
  validates :title, :project_description, :presence => true, :format => /\A[\w ,\.]+\z/
  validates :user_id, :presence => true, :format => /\d+/ 
  validates :rev_project_name, uniqueness: true, :format => /\A\w+\z/
  
end
