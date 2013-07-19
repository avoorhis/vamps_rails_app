class User < ActiveRecord::Base
	has_many :projects
	has_many :datasets, :through => :projects
	attr_accessor :login
	devise :database_authenticatable,	:registerable, 
  			:recoverable,  				:rememberable,
    		:trackable,     			:validatable,
     		:authentication_keys => [:login]

    has_many :projects
    has_many :datasets, :through => :projects

    def self.find_first_by_auth_conditions(warden_conditions)
      conditions = warden_conditions.dup
      if login = conditions.delete(:login)
        where(conditions).where(["lower(user) = :value OR lower(email) = :value", { :value => login.downcase }]).first
      else
        where(conditions).first
      end
    end
end
