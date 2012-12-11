class HomeController < ApplicationController

  def index
    @present_budget = session[:budget]
  end

end
