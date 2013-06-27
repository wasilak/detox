class Tag < ActiveRecord::Base
  has_many :expenses_tags_association, :dependent => :delete_all
	has_many :expenses, :through => :expenses_tags_association

	belongs_to :user

	validates :name, :presence => true, :uniqueness => { :scope => :user_id, :message => "you already have this tag" }
	validates :user_id, :presence => true

  	def count_expenses
  		expenses.all
  	end
end
