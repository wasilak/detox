class Expense < ActiveRecord::Base
	belongs_to :user
	has_many :expenses_tags_association, :dependent => :destroy

	validates :amount, :presence => true, :numericality => { :greater_than => 0}
	validates :date, :presence => true
	validates :description, :presence => true
	validates :userId, :presence => true

  	attr_accessible :amount, :date, :description, :userId

  	def getTags
  		expenses_tags_association.all
  	end

    def self.getExpenses user_id, date_start, date_end
      self.order("date desc")
        .where('date >= ? and date <= ?', date_start, date_end)
        .where(:userId => user_id)
        .includes(:expenses_tags_association => :tag)
        .all
    end

    def self.getExpensesBudget user_id, date_start, date_end
      self.order("date desc")
      .where('date >= ? and date <= ?', date_start, date_end)
      .where({
                 :userId => user_id,
                 :tags => {:budget => 1}
             })
      .includes(:expenses_tags_association => :tag)
      .all
    end

    def self.getExpensesBudgetSum user_id, date_start, date_end
      self.where('user_id = ? and date >= ? and date <= ? and budget = 1', user_id, date_start, date_end)
        .joins(:expenses_tags_association => :tag ).sum(:amount)
    end

    def self.getAll user_id
      output = {}

      output[:dateStart] = self.where(:userId => user_id).minimum(:date)
      output[:dateEnd] = self.where(:userId => user_id).maximum(:date)

      output[:description] = 'all expenses'
      output[:id] = 0

      output[:userId] = user_id

      output
    end

    def self.getAllSum
      self.where(:userId).sum(:amount)
    end

    def self.getByDate user_id, date, budget_start, budget_end
      self.joins(:expenses_tags_association => :tag)
        .where({:userId => user_id})
        .where({:date => date})
        .where("date >= ? and date <= ?", budget_start, budget_end)
        .where({:tags => {:budget => 1}})
        .sum(:amount)
    end

end
