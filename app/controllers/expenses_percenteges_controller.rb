class ExpensesPercentegesController < ApplicationController

  # GET /expenses
  # GET /expenses.json
  def index
    @expenses = Expense.get_expenses_percenteges(
      current_user[:id],
      session[:budget]['dateStart'],
      session[:budget]['dateEnd'],
    )
  end

  private

end
