class ApplicationController < ActionController::Base
  add_breadcrumb "home", :root_path

  protect_from_forgery

  before_filter :login_required
  before_filter :remainingBudget

  private

  def login_required
    if session[:userId]
      @loggedIn = true
      return true
    end
    flash[:warning]='Please login to continue'
    # session[:return_to]=request.request_uri
    redirect_to :controller => "home", :action => "login"
    return false
  end

  def correct_value number
    # zamiana przecinkow na kropki :)
    if number =~ /,/
      number = number.gsub(/,/, ".")
    end

    number
  end

  def remainingBudget
    if session[:user]
      if session[:budget][0][:id] != 0
        expenses = Expense.getExpenses(
          session[:user][:id],
          session[:budget][0][:dateStart],
          session[:budget][0][:dateEnd]
          )

        expensesSum = 0
        expenses.each do |expense|
          expensesSum += expense[:amount]
        end

        budgetAmount = Budget.find(session[:budget][0][:id])
        @remainingBudget = budgetAmount[:amount] - expensesSum
        @remainingBudgetPercentage = (100*@remainingBudget)/budgetAmount[:amount]
      else
        @remainingBudget = 0
      end
    end
  end

end
