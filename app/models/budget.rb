class Budget < ActiveRecord::Base
    belongs_to :user
    # has_many :expenses_tags_association

    validates :amount, :presence => true, :numericality => { :greater_than => 0}
    # validates :date, :presence => true
    # validates :description, :presence => true
    # validates :userId, :presence => true

    attr_accessible :amount, :dateStart, :dateEnd, :description, :userId

    # def getTags
    #     expenses_tags_association.find(:all)
    # end

    def self.getAllBudgets
        self.find(:all)
    end

end
