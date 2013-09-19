class Family < ActiveRecord::Base
  has_many :taxonomies  
  # has_many :sequence_uniq_infos, :through => :taxonomies  
end
