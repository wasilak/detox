class Budget < ActiveRecord::Base
    belongs_to :user
    # has_many :expenses_tags_association

    validates :amount, :presence => true, :numericality => { :greater_than => 0}
    validates :dateStart, :presence => true
    validates :dateEnd, :presence => true
    validates :description, :presence => true

    attr_accessible :amount, :dateStart, :dateEnd, :description, :userId

    # def getTags
    #     expenses_tags_association.find(:all)
    # end

    def self.getAllBudgets
        self.find(:all)
    end

    def self.getAllUserBudgets(userId)
        self.find(
            :all,
            :conditions => ['userId = ?', userId]
        )
    end

    def self.getBudget(date, userId)
        date = "#{date.year}-#{date.month}-#{date.day}"
        self.find(
            :all,
            :conditions => ['dateStart <= ? and dateEnd >= ? and userId = ?', date, date, userId]
            )
    end

    def self.getBudgetById(budgetId)
        self.find(
            :all,
            :conditions => ['id = ?', budgetId]
        )
    end
end
