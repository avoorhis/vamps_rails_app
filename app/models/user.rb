class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable
  
         
  has_many  :projects

  validates_uniqueness_of :email, :scope => [:first_name, :last_name, :institution]
  validates_uniqueness_of :username
         
  # attr_accessible :email, :password, :password_confirmation, :remember_me
         
  #   has_and_belongs_to_many :contacts
  #   
  # has_many  :projects, :through => :contacts
  # 
  #     
  # attr_accessor :login
  # devise :database_authenticatable, :registerable, 
  #         :recoverable,         :rememberable,
  #         :trackable,           :validatable,
  #         :authentication_keys => [:login]
  # 
  #   def self.find_first_by_auth_conditions(warden_conditions)
  #     conditions = warden_conditions.dup
  #     if login = conditions.delete(:login)
  #       # where(conditions).where(["lower(user) = :value OR lower(email) = :value", { :value => login.downcase }]).first
  #     else
  #       where(conditions).first
  #     end
  #   end
end
