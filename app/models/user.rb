class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_and_belongs_to_many :contacts
  
	has_many  :projects, :through => :contacts
	
	validates :user, uniqueness: true
  	
	attr_accessor :login
	devise :database_authenticatable,	:registerable, 
  			:recoverable,  				:rememberable,
    		:trackable,     			:validatable,
     		:authentication_keys => [:login]

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      # where(conditions).where(["lower(user) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      where(conditions).first
    end
  end
end
