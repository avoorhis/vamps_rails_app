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
         
  attr_accessible :username, :email, :institution, :first_name, :last_name, :password, :password_confirmation, :remember_me
end
