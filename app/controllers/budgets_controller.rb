class BudgetsController < ApplicationController

  skip_before_filter :login_required, :only => [:login, :checkLogin]

  def index
    @budgets = Budget.getAllBudgets
  end

end
