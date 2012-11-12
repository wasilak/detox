class Expense < ActiveRecord::Base
	belongs_to :user
	has_many :expenses_tags_association

	validates :amount, :presence => true, :numericality => { :greater_than => 0}
	validates :date, :presence => true
	validates :description, :presence => true
	validates :userId, :presence => true

  	attr_accessible :amount, :date, :description, :userId

  	def getTags
  		expenses_tags_association.find(:all)
  	end

    def self.getExpenses(userId, dateStart, dateEnd)
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

    def self.getAll(userId)
      output = []
      output[0] = {}

      output[0][:dateStart] = self.where(:userId => userId).minimum(:date)
      output[0][:dateEnd] = self.where(:userId => userId).maximum(:date)

      output[0][:description] = 'all expenses'

      output[0][:userId] = userId

      return output
    end

end
