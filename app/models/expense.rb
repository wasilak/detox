class Expense < ActiveRecord::Base
  attr_accessible :amount, :date, :description, :userId
end
