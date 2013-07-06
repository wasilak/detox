class ApplicationController < ActionController::Base

  protect_from_forgery

  before_filter :authenticate_user!
  before_filter :check_budget
  before_filter :remaining_budget

  # fix for i18n after adding Active Admin
  before_filter :set_locale
  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end
  # end of fix

  def correct_value (number)
    # zamiana przecinkow na kropki :)
    if number =~ /,/
      number = number.gsub(/,/, ".")
    end

    number
  end

  def check_budget
    # TODO: fix this odd workaround to set correct budget on log in
    if user_signed_in? and session[:budget].nil?
      session[:budget] = Budget.get_budget(Time.new,current_user[:id])
    end
    if user_signed_in? and session[:budget].nil?
      set_session_budget 1
    end
  end

  def remaining_budget
    if current_user and session[:budget]

      if session[:budget][:id] != 0
      
        calculate_budget
     
      else
        @remaining_budget = 0
        @remaining_budget_percentage = 0
      end
    end
  end

  def calculate_budget
    expenses = Expense.get_expenses_budget(
          current_user[:id],
          session[:budget][:dateStart],
          session[:budget][:dateEnd]
          )
    calculate_budget_details expenses        
  end

  def calculate_expenses_sum expenses
    expenses_sum = 0
    expenses.each do |expense|
      if expense[:half] == 1
        expenses_sum += expense[:amount] / 2
      else
        expenses_sum += expense[:amount]
      end
    end
    expenses_sum
  end

  def calculate_budget_details expenses
    budget = Budget.find(session[:budget][:id]) rescue nil # so we can delete active budget

    unless budget.nil?
      @remaining_budget = budget[:amount] - calculate_expenses_sum(expenses)

      @remaining_budget_percentage = (100*@remaining_budget)/budget[:amount]

      if (Date.today < session[:budget][:dateEnd])
        @days_left_in_budget = (session[:budget][:dateEnd] - Date.today).to_i
        @budget_left_per_day = @remaining_budget / @days_left_in_budget
      else
        @days_left_in_budget = 0
        @budget_left_per_day = 0
      end

    end
  end

  def set_session_budget (all = 0)
    if params[:budget] == 'all' or all == 1
     session[:budget] = Expense.get_all(current_user[:id])
    else
      session[:budget] = Budget.get_budget_by_id(params[:budget])
    end
  end

  def log variable, info = ""
    logger.debug "\033[31m#{info} #{variable.inspect}\033[0m"
  end
end
