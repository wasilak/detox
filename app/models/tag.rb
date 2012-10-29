class Tag < ActiveRecord::Base
	has_many :expenses_tags_association
  	attr_accessible :name, :description

	validates :name, :presence => true

  	def countExpenses
  		expenses_tags_association.find(:all).count
  	end
end
