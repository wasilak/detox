class MigrateHalfToPercentage < ActiveRecord::Migration
  def change
    Expense.find_each do |expense|
      if expense.share_percentage == 1
        expense.share_percentage = 0.5
      end
      expense.save!
    end
  end
end
