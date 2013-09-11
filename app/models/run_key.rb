class RunKey < ActiveRecord::Base
  has_many  :run_infos

  validates :run_key, uniqueness: true
  
end
