class PrimerSuite < ActiveRecord::Base
  belongs_to :run_key
  
  has_and_belongs_to_many :primers
  validates :primer_suite, uniqueness: true
  
end
