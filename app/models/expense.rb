class Expense < ActiveRecord::Base
	belongs_to :user
	has_many :expenses_tags_association, :dependent => :destroy

	validates :amount, :presence => true, :numericality => { :greater_than => 0}
	validates :date, :presence => true
	validates :description, :presence => true
	validates :userId, :presence => true

  	attr_accessible :amount, :date, :description, :userId

  	def getTags
  		expenses_tags_association.find(:all)
  	end

    def self.getExpenses userId, dateStart, dateEnd
        self.find(
          :all,
          :conditions =>  ['userId = ? and date >= ? and date <= ?',
            "#{userId}",
            "#{dateStart}",
            "#{dateEnd}"],
          :order  =>  ['date desc'],
          :include => { :expenses_tags_association => :tag }
        )
    end

    def self.getExpensesBudget userId, dateStart, dateEnd
        self.find(
          :all,
          :conditions =>  ['userId = ? and date >= ? and date <= ? and budget = 1',
            "#{userId}",
            "#{dateStart}",
            "#{dateEnd}"],
          :order  =>  ['date desc'],
          :joins => { :expenses_tags_association => :tag }
        )
    end

    def self.getAll userId
      # output = []
      output = {}

      output[:dateStart] = self.where(:userId => userId).minimum(:date)
      output[:dateEnd] = self.where(:userId => userId).maximum(:date)

      output[:description] = 'all expenses'
      output[:id] = 0

      output[:userId] = userId

      return output
    end

    def self.getAllSum userId
      self.where(:userId).sum(:amount)
    end

    def self.getByDate date, budgetStart, budgetEnd
      self.joins(:expenses_tags_association => :tag)
        .where({:date => date})
        .where("date >= ? and date <= ?", budgetStart, budgetEnd)
        .where({:tags => {:budget => 1}})
        .sum(:amount)
    end

end
