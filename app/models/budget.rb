class Budget < ActiveRecord::Base
    belongs_to :user
    # has_many :expenses_tags_association

    validates :amount, :presence => true, :numericality => { :greater_than => 0}
    validates :dateStart, :presence => true, :uniqueness => { :scope => :userId}
    validates :dateEnd, :presence => true, :uniqueness => { :scope => :userId}
    validates :description, :presence => true

    attr_accessible :amount, :dateStart, :dateEnd, :description, :userId

    def end_date_cannot_be_lower_then_start_date
        if !dateEnd.blank? and dateEnd < dateStart
          errors.add(:dateEnd, "can't be lower then start date")
        end
    end

    def self.getAllBudgets userId
        self.where(:userId => userId)
    end

    def self.getAllUserBudgets userId
      self.where(
          :userId => userId
        )
        .all
    end

    def self.getBudget date, userId
        date = "#{date.year}-#{date.month}-#{date.day}"
        self.where('dateStart <= ? and dateEnd >= ? and userId = ?', date, date, userId).first
    end

    def self.getBudgetById budgetId
      self.where(:id => budgetId).all
    end
end
