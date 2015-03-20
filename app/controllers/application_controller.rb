class ApplicationController < ActionController::Base

  rescue_from Exception, with: :render_500_page
  rescue_from ActiveRecord::RecordNotFound, with: :render_404_page_exception

  protect_from_forgery

  before_filter :authenticate_user!
  before_filter :check_budget
  before_filter :remaining_budget
  before_filter :budget_select

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

  def budget_select
    if user_signed_in?
      @budgets = Budget.get_all_user_budgets(current_user[:id])
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
      expenses_sum += expense.amount * (1 - expense.share_percentage)
    end
    expenses_sum
  end

  def calculate_budget_details expenses
    budget = session[:budget]

    unless budget.nil?
      @remaining_budget = budget[:amount] - calculate_expenses_sum(expenses)

      @remaining_budget_percentage = (100 * @remaining_budget) / budget[:amount]

      get_day_related_budget_details
    end
  end

  def get_day_related_budget_details
    if (Date.today < session[:budget][:dateEnd])
      @days_left_in_budget = (session[:budget][:dateEnd] - Date.today).to_i
      @budget_left_per_day = @remaining_budget / @days_left_in_budget
    else
      @days_left_in_budget = 0
      @budget_left_per_day = 0
    end
  end

  def set_session_budget (all = 0)
    if params[:budget] == 'all' or all == 1
     session[:budget] = Expense.get_all(current_user[:id])
    else

      param = params[:budget].split('-')

      # budget ID
      if 1 == param.count
        session[:budget] = Budget.get_budget_by_id(params[:budget])
      else
        session[:budget] = Expense.get_predefined_budget current_user[:id], params[:budget]
      end
    end
  end

  def log variable, info = ""
    logger.debug "\033[31m#{info} #{variable.inspect}\033[0m"
  end

  def render_404_page_exception exception
    @exception = exception
    render "error_pages/404.html.erb", status: 404
  end

  def render_404_page
    @exception = 'Page not found.'
    render "error_pages/404.html.erb", status: 404
  end

  def render_500_page exception
    @exception = exception
    render "error_pages/500.html.erb", status: 500
  end

end
