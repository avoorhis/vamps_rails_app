class Order < ActiveRecord::Base
  has_many :taxonomies  
end
