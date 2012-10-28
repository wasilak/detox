class ExpensesTagsAssociation < ActiveRecord::Base
	belongs_to :tag
	belongs_to :expense
  	attr_accessible :expense_id, :tag_id

  	validates :tag_id, :presence => true, :uniqueness => { :scope => :expense_id, :message => "this tag has already been assigned" }

end
