class ApplicationController < ActionController::Base
  add_breadcrumb "home", :root_path

  protect_from_forgery

  before_filter :authenticate_user!
  before_filter :check_budget
  before_filter :remaining_budget

  private

  def correct_value (number)
    # zamiana przecinkow na kropki :)
    if number =~ /,/
      number = number.gsub(/,/, ".")
    end

    number
  end

  def check_budget
    if user_signed_in? and session[:budget].nil?
      session[:budget] = Budget.get_budget(Time.new,current_user[:id])
    end
  end

  def remaining_budget
    if current_user and session[:budget]
      if session[:budget][:id] != 0
        expenses = Expense.get_expenses_budget(
          current_user[:id],
          session[:budget][:dateStart],
          session[:budget][:dateEnd]
          )

        expenses_sum = 0
        expenses.each do |expense|
          expenses_sum += expense[:amount]
        end

        budget_amount = Budget.find(session[:budget][:id])
        @remaining_budget = budget_amount[:amount] - expenses_sum

        @remaining_budget_percentage = (100*@remaining_budget)/budget_amount[:amount]

        @days_left_in_budget = (session[:budget][:dateEnd] - Date.today).to_i
        @budget_left_per_day = @remaining_budget / @days_left_in_budget
      else
        @remaining_budget = 0
        @remaining_budget_percentage = 0
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

end
