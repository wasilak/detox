class HomeController < ApplicationController

  # skip_before_filter :login_required, :only => [:login, :check_login]
  # skip_before_filter :check_budget, :only => [:index]

  def index
    @present_budget = session[:budget]
  end

end
