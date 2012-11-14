class BudgetsController < ApplicationController

  skip_before_filter :login_required, :only => [:login, :checkLogin]

  def index
    @budgets = Budget.getAllBudgets session[:user][:id]
  end

  def new
    # example of Airbrake notification
    # Airbrake.notify(Exception.new("eoor!"))

    @budget = Budget.new
  end

  def create
    params[:budget][:amount] = correct_value(params[:budget][:amount])

    @budget = Budget.new(params[:budget])

    respond_to do |format|
      if @budget.save
        session[:budget] = Budget.getBudget(Time.new,session[:user][:id])
        format.html { redirect_to budgets_url, notice: 'budget was successfully created.' }
        format.json { render json: @budget, status: :created, location: @budget }
      else
        format.html { render action: "new" }
        format.json { render json: @budget.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @budget = Budget.find(params[:id])
  end

  def update
    params[:budget][:amount] = correct_value(params[:budget][:amount])

    @budget = Budget.find(params[:id])

    respond_to do |format|
      if @budget.update_attributes(params[:budget])
        session[:budget] = Budget.getBudget(Time.new,session[:user][:id])
        format.html { redirect_to budgets_path, notice: 'budget was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @budget.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @budget = Budget.find(params[:id])
    @budget.destroy

    respond_to do |format|
      format.html { redirect_to budgets_url }
      format.json { head :no_content }
    end
  end

end
