class PrimerSuite < ActiveRecord::Base
  has_many   :run_infos  
  has_and_belongs_to_many :primers
  validates :primer_suite, uniqueness: true
  
end
