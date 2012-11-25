class Budget < ActiveRecord::Base
    belongs_to :user

    validates :amount, :presence => true, :numericality => { :greater_than => 0}
    validates :dateStart, :presence => true, :uniqueness => { :scope => :userId}
    validates :dateEnd, :presence => true, :uniqueness => { :scope => :userId}
    validates :description, :presence => true

    attr_accessible :amount, :dateStart, :dateEnd, :description, :userId

    #def end_date_cannot_be_lower_then_start_date
    #    if !dateEnd.blank? and dateEnd < dateStart
    #      errors.add(:dateEnd, "can't be lower then start date")
    #    end
    #end

    def self.get_all_budgets user_id
        self.where(:userId => user_id)
    end

    def self.get_all_user_budgets user_id
      self.where(
          :userId => user_id
        )
        .all
    end

    def self.get_budget date, user_id
        date = "#{date.year}-#{date.month}-#{date.day}"
        self.where('dateStart <= ? and dateEnd >= ? and userId = ?', date, date, user_id).first
    end

    def self.get_budget_by_id budget_id
      self.where(:id => budget_id).first
    end
end
