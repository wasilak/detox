class Expense < ActiveRecord::Base
	belongs_to :user
	has_many :expenses_tags_association, :dependent => :destroy

	validates :amount, :presence => true, :numericality => { :greater_than => 0}
	validates :date, :presence => true
	validates :description, :presence => true
	validates :userId, :presence => true

  	attr_accessible :amount, :date, :description, :userId

  	def get_tags
  		expenses_tags_association.all
  	end

    def self.get_expenses user_id, date_start, date_end
      self.order("date desc")
        .where('date >= ? and date <= ?', date_start, date_end)
        .where(:userId => user_id)
        .includes(:expenses_tags_association => :tag)
        .all
    end

    def self.get_expenses_budget user_id, date_start, date_end
      self.order("date desc")
      .where('date >= ? and date <= ?', date_start, date_end)
      .where({
                 :userId => user_id,
                 :tags => {:budget => 1}
             })
      .includes(:expenses_tags_association => :tag)
      .all
    end

    def self.get_expenses_budget_sum user_id, date_start, date_end
      self.where('user_id = ? and date >= ? and date <= ? and budget = 1', user_id, date_start, date_end)
        .joins(:expenses_tags_association => :tag ).sum(:amount)
    end

    def self.get_all user_id
      output = {}

      output[:dateStart] = self.where(:userId => user_id).minimum(:date)
      output[:dateEnd] = self.where(:userId => user_id).maximum(:date)

      output[:description] = 'all expenses'
      output[:id] = 0

      output[:userId] = user_id

      output
    end

    def self.get_all_sum
      self.where(:userId).sum(:amount)
    end

    def self.get_by_date user_id, date, budget_start, budget_end
      self.joins(:expenses_tags_association => :tag)
        .where({:userId => user_id})
        .where({:date => date})
        .where("date >= ? and date <= ?", budget_start, budget_end)
        .where({:tags => {:budget => 1}})
        .sum(:amount)
    end

end
