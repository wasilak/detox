class HomeController < ApplicationController

  skip_before_filter :login_required, :only => [:login, :checkLogin]
  skip_before_filter :checkBudget, :only => [:login, :checkLogin, :logout]

  def index
    @presentBudget = session[:budget]
  end

  def login
  end

  def checkLogin
  	username = params[:username]
  	password = params[:password]

    check = User.checkLogin(username, password)

  	if (false != check)
  		session[:userId] = check.id
      flash[:success]='Log in successfull :)!'
      session[:user] = check
      session[:budget] = Budget.getBudget(Time.new,session[:user][:id])
      redirect_to :controller => "home", :action => "index"
  	 else
  		flash[:warning]=(I18n.t 'log in name or password incorrect!')
	    redirect_to :controller => "home", :action => "login"
	end
  end

  def logout
    reset_session
    redirect_to :controller => "home", :action => "login"
  end
end
