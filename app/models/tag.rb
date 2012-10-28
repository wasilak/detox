class Tag < ActiveRecord::Base
	has_many :expenses_tags_association
  	attr_accessible :name

  	def countExpenses
  		expenses_tags_association.find(:all).count
  	end
end
