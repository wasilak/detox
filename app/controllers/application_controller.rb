class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :login_required

  def login_required
    if session[:username]
      @loggedIn = true
      return true
    end
    flash[:warning]='Please login to continue'
    # session[:return_to]=request.request_uri
    redirect_to :controller => "home", :action => "login"
    return false
  end

end
