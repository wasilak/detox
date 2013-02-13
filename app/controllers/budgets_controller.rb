class BudgetsController < ApplicationController

  skip_before_filter :login_required, :only => [:login, :checkLogin]

  def index
    @budgets = Budget.get_all_budgets current_user[:id]
  end

  def new
    # example of Airbrake notification
    # Airbrake.notify(Exception.new("eoor!"))

    @budget = Budget.new
  end

  def create
    params[:budget][:amount] = correct_value(params[:budget][:amount])

    @budget = Budget.new(params[:budget])

    if @budget.save
      session[:budget] = Budget.get_budget(Time.new,current_user[:id])
      redirect_to budgets_url, notice: (I18n.t 'Budget was successfully created.')
    else
      render action: "new"
    end
  end

  def edit
    @budget = Budget.find(params[:id])
  end

  def update
    params[:budget][:amount] = correct_value(params[:budget][:amount])

    @budget = Budget.find(params[:id])

    if @budget.update_attributes(params[:budget])
      session[:budget] = Budget.get_budget(Time.new,current_user[:id])
      redirect_to budgets_path, notice: (I18n.t 'Budget was successfully updated.')
    else
      render action: "edit"
    end
  end

  def destroy
    @budget = Budget.find(params[:id])
    @budget.destroy

    redirect_to budgets_url, notice: (I18n.t 'Budget was successfully deleted.')
  end

end
