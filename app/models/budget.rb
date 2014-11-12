class Budget < ActiveRecord::Base
    belongs_to :user

    validates :amount, :presence => true, :numericality => { :greater_than => 0}
    validates :dateStart, :presence => true
    validates :dateEnd, :presence => true
    validates :description, :presence => true

    #def end_date_cannot_be_lower_then_start_date
    #    if !dateEnd.blank? and dateEnd < dateStart
    #      errors.add(:dateEnd, "can't be lower then start date")
    #    end
    #end

    def self.get_all_budgets user_id
        self.where(:userId => user_id).order("dateStart desc")
    end

    def self.get_all_user_budgets user_id
      self.where(
          :userId => user_id
        )
        .load
    end

    def self.get_virtual_budgets
      monthsRaw = Expense.uniq.pluck("DATE_FORMAT(date,'%m-%Y')")
      yearsRaw = Expense.uniq.pluck("DATE_FORMAT(date,'%Y')")

      logger.debug yearsRaw

      items = [["all expenses","all"]]
      monthsRaw.each do |item|
        elements = item.split '-'
        items.push(["#{elements[0]}-#{elements[1]}", "month-#{item}"])
      end

      yearsRaw.each do |item|
        items.push([item, "year-00-#{item}"])
      end

      # logger.debug months.inspect
      items
    end

    def self.get_budget date, user_id
        date = "#{date.year}-#{date.month}-#{date.day}"
        self.where('dateStart <= ? and dateEnd >= ? and userId = ?', date, date, user_id).first
    end

    def self.get_budget_by_id budget_id
      self.where(:id => budget_id).first
    end

    def get_budget_expenses is_budget = 1
      sql = Expense
        .order("date desc")
        .where('date >= ? and date <= ?', dateStart, dateEnd)
        .where({
                   :userId => userId
               })

      if 1 == is_budget or 0 == is_budget
        sql = sql.where({
                 :tags => {:budget => is_budget}
             })
      end

      sql = sql.joins(:tags)
        .sum(:amount)
    end

end
