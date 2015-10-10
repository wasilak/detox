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

      items = [["all expenses","all"]]
      monthsRaw.each do |item|
        elements = item.split '-'
        items.push(["#{elements[0]}-#{elements[1]}", "month-#{item}"])
      end

      yearsRaw.each do |item|
        items.push([item, "year-00-#{item}"])
      end

      items
    end

    def self.get_budget date, user_id
        date = "#{date.year}-#{date.month}-#{date.day}"

        budget = self
          .where("dateStart <= ?", date)
          .where("dateEnd >= ?", date)
          .where("userId = ?", user_id)
          .first

        if budget.nil?
          budget = Expense.get_all(user_id)
        end

        budget
    end

    def self.get_budget_by_id budget_id
      self.where(:id => budget_id).first
    end

    def get_budget_expenses is_budget = 1, consider_percenteges = false
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

      if consider_percenteges
        sql = sql.joins(:tags)
        expenses = 0;

        sql.each do |expense|
          expenses += expense.amount * (1 - expense.share_percentage);
        end
        return expenses;
      end
      sql = sql.joins(:tags)
        .sum(:amount)
    end

end
