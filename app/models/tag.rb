class Tag < ActiveRecord::Base
	has_many :expenses_tags_association
	belongs_to :user
  	attr_accessible :name, :description, :user_id

	validates :name, :presence => true, :uniqueness => { :scope => :user_id, :message => "you already have this tag" }
	validates :user_id, :presence => true

  	def countExpenses
  		expenses_tags_association.find(:all).count
  	end
end
