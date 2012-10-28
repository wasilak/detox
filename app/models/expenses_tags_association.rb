class ExpensesTagsAssociation < ActiveRecord::Base
	belongs_to :tag
	has_one :expense
  	attr_accessible :expense_id, :tag_id

  	validates :tag_id, :presence => true
end
