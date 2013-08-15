class ExpensesTagsAssociation < ActiveRecord::Base
	belongs_to :tag
	belongs_to :expense

  	validates :tag_id, :presence => true, :uniqueness => { :scope => :expense_id, :message => "this tag has already been assigned" }

    def self.clear_for_expense(expense_id)
      self.where('expense_id = ?', expense_id).destroy_all
    end

end
