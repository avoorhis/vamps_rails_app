class Contact < ActiveRecord::Base
  has_and_belongs_to_many :users

  has_many  :projects
  
  validates_uniqueness_of :contact, :scope => [:email, :institution]
  
end
