class Dataset < ActiveRecord::Base
  belongs_to :project
  belongs_to :user

  validates :dataset, :dataset_description, :presence => true, :format => /[A-Za-z1-9]/
  validates :project_id, :presence => true

end
