class ExpensesTagsAssociation < ActiveRecord::Base
	belongs_to :tag
	belongs_to :expense
  attr_accessible :expense_id, :tag_id
end
