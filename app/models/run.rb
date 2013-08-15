class Run < ActiveRecord::Base
  has_many  :run_infos

  validates :run, uniqueness: true
  
end
