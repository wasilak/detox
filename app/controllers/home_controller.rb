class HomeController < ApplicationController

  skip_before_filter :login_required, :only => [:login, :check_login]
  skip_before_filter :check_budget, :only => [:login, :check_login, :logout]

  def index
    @present_budget = session[:budget]
  end

  def login
  end

  def check_login
  	username = params[:username]
  	password = params[:password]

    check = User.check_login(username, password)

  	if check
  		session[:userId] = check.id
      flash[:success]=(I18n.t 'Log in successfull')+' :)'
      session[:user] = check
      session[:budget] = Budget.get_budget(Time.new,session[:user][:id])
      redirect_to :controller => "home", :action => "index"
  	 else
  		flash[:warning]=(I18n.t 'log in name or password incorrect')+'!'
	    redirect_to :controller => "home", :action => "login"
	end
  end

  def logout
    reset_session
    redirect_to :controller => "home", :action => "login"
  end
end
