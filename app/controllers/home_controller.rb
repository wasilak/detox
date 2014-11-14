class HomeController < ApplicationController

  def index
    @expenses_count_budget = Expense.get_all_count current_user[:id], 1
    @expenses_count = Expense.get_all_count current_user[:id], 0
    @expenses_all = @expenses_count_budget + @expenses_count
    @expenses_percentage = @expenses_count_budget * 100 / @expenses_all

    @budgets_count = Budget.get_all_budgets(current_user[:id]).count

    @tags_count = Tag.get_all(current_user[:id])

    @present_budget = session[:budget]
  end

end
