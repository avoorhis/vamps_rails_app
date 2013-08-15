class Primer < ActiveRecord::Base
  # has_and_belongs_to_many :primer_suites

  validates :direction, inclusion: { in: ["F", "R"], message: "%{value} is not a valid direction" }
  validates :domain,    inclusion: { in: ["bacteria", "archaea", "eukarya", ""], message: "%{value} is not a valid domain" }
  
  validates :primer, uniqueness: true
  
end
