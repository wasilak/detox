class User < ActiveRecord::Base
	has_many :expense

	validates :username, :presence => true, :uniqueness => true
	validates :password, :presence => true
	validates :name, :presence => true
	validates :userType, :presence => true

  	attr_accessible :name, :password, :userType, :username
end
