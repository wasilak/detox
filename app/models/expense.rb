class Expense < ActiveRecord::Base
	belongs_to :user
	has_many :expenses_tags_association

	validates :amount, :presence => true
	validates :date, :presence => true
	validates :description, :presence => true
	validates :userId, :presence => true

  	attr_accessible :amount, :date, :description, :userId

  	def getTags
  		expenses_tags_association.find(:all)
  	end
end
