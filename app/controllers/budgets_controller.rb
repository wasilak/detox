class BudgetsController < ApplicationController

  skip_before_filter :login_required, :only => [:login, :checkLogin]

  def budget_params
    params.require(:budget).permit(:amount, :dateStart, :dateEnd, :description, :userId)
  end

  def index
    @budgets = Budget.get_all_budgets current_user[:id]
    @chart_data = budget_chart @budgets
  end

  def new
    # example of Airbrake notification
    # Airbrake.notify(Exception.new("eoor!"))

    @budget = Budget.new
  end

  def create
    budget_params[:amount] = correct_value(budget_params[:amount])

    @budget = Budget.new(budget_params)

    if @budget.save
      set_budget_and_redirect
    else
      render action: "new"
    end
  end

  def edit
    @budget = Budget.find(params[:id])
  end

  def update
    budget_params[:amount] = correct_value(budget_params[:amount])

    @budget = Budget.find(params[:id])

    if @budget.update_attributes(budget_params)
      set_budget_and_redirect
    else
      render action: "edit"
    end
  end

  def destroy
    @budget = Budget.find(params[:id])
    @budget.destroy

    redirect_to budgets_url, notice: (I18n.t 'Budget was successfully deleted.')
  end

  def set_budget_and_redirect
    session[:budget] = Budget.get_budget(Time.new,current_user[:id])
    redirect_to budgets_path, notice: (I18n.t 'Budget was successfully updated.')
  end

  def budget_chart budgets
    # logger.debug "All: #{budgets.inspect}"
    chart_data = {}

    chart_data[:categories] = []

    data_all = {}
    data_all[:name] = 'All'
    data_all[:data] = []

    data_in_budget = {}
    data_in_budget[:name] = 'Budget'
    data_in_budget[:data] = []

    data_non_budget = {}
    data_non_budget[:name] = 'Non-budget'
    data_non_budget[:data] = []

    budgets.each do |budget|
      all = budget.get_budget_expenses 'all'
      in_budget = budget.get_budget_expenses
      non_budget = budget.get_budget_expenses 0

      chart_data[:categories].push(budget.description)

      data_all[:data].push(all)
      data_in_budget[:data].push(in_budget)
      data_non_budget[:data].push(non_budget)

      # chart_data[:series][:all].push(all)
      # chart_data[:series][:budget].push(in_budget)
      # chart_data[:series][:non_budget].push(non_budget)
    end

    chart_data[:series] = []
    chart_data[:series].push(data_all)
    chart_data[:series].push(data_in_budget)
    chart_data[:series].push(data_non_budget)

    chart_data.to_json
  end

end
