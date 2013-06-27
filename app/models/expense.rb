class Expense < ActiveRecord::Base
	belongs_to :user
  has_many :expenses_tags_association, :dependent => :destroy
	has_many :tags, :through => :expenses_tags_association

	validates :amount, :presence => true, :numericality => { :greater_than => 0}
	validates :date, :presence => true
	validates :description, :presence => true
	validates :userId, :presence => true

    @tags = []

  	def get_tags
  		expenses_tags_association.includes(:tag).load
  	end

    def self.get_expenses user_id, date_start, date_end, order = 'date desc'
      sql = self
          .where('date >= ? and date <= ?', date_start, date_end)
          .where(:userId => user_id)
          .order(order)

      if !@tags.nil? and @tags.size > 0
        sql = sql.includes(:tags, :expenses_tags_association).where(:tags => {:name => @tags})
      else
        sql = sql.includes(:tags)
      end

      sql.load
    end

    def self.get_expenses_budget user_id, date_start, date_end
      self
      .order("date desc")
      .where('date >= ? and date <= ?', date_start, date_end)
      .where({
                 :userId => user_id,
                 :tags => {:budget => 1}
             })
      .joins(:tags)
      .load
    end

    def self.get_expenses_budget_sum user_id, date_start, date_end
      self.where('user_id = ? and date >= ? and date <= ? and budget = 1', user_id, date_start, date_end)
        .joins(:tags ).sum(:amount)
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
      self.joins(:tags)
        .where({:userId => user_id})
        .where({:date => date})
        .where("date >= ? and date <= ?", budget_start, budget_end)
        .where({:tags => {:budget => 1}})
        .sum(:amount)
    end

    def self.set_tags tags
      @tags = tags
    end

    def self.get_current_tags
      @tags
    end

end
