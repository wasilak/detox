class Expense < ActiveRecord::Base
	belongs_to :user
	has_many :tag

	validates :amount, :presence => true
	validates :date, :presence => true
	validates :description, :presence => true
	validates :userId, :presence => true

  	attr_accessible :amount, :date, :description, :userId

  	def getTags
  		tag.find(:all)
  	end
end
