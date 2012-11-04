class BudgetsController < ApplicationController

  skip_before_filter :login_required, :only => [:login, :checkLogin]

  def index
  end

end
