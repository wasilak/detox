class ApplicationController < ActionController::Base
  add_breadcrumb "home", :root_path

  protect_from_forgery

  before_filter :login_required
  before_filter :checkBudget
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

  def checkBudget
    unless session[:budget]
      setSessionBudget 1
    end
  end

  def remainingBudget
    if session[:user] and session[:budget]
      if session[:budget][:id] != 0
        expenses = Expense.getExpensesBudget(
          session[:user][:id],
          session[:budget][:dateStart],
          session[:budget][:dateEnd]
          )

        expensesSum = 0
        expenses.each do |expense|
          expensesSum += expense[:amount]
        end

        budgetAmount = Budget.find(session[:budget][:id])
        @remainingBudget = budgetAmount[:amount] - expensesSum

        @remainingBudgetPercentage = (100*@remainingBudget)/budgetAmount[:amount]

        @expensesToday = Expense.getByDate Date.today, session[:budget][:dateStart], session[:budget][:dateEnd]
        @daysInBudget = (session[:budget][:dateEnd] - session[:budget][:dateStart]).to_i
        @budgetToday = session[:budget][:amount] / @daysInBudget
        @remainingBudgetDay = @budgetToday - @expensesToday
      else
        @remainingBudget = 0
      end
    end
  end

  def setSessionBudget all = 0

    if params[:budget] == 'all' or all == 1
     session[:budget] = Expense.getAll(session[:user][:id])
    else
      session[:budget] = Budget.getBudgetById(params[:budget]).first
    end
  end

end
