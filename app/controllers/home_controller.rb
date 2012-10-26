class HomeController < ApplicationController

  skip_before_filter :login_required, :only => [:login, :checkLogin]

  def index
  end

  def login
  end

  def checkLogin
  	username = params[:username]
  	password = params[:password]
  	# password = Digest::MD5.hexdigest(params[:password])
  	# render :text => username+' : '+password

  	if (User.checkLogin(username, password))
  		session[:username] = username
      flash[:success]='Log in successfull :)!'
      redirect_to :controller => "home", :action => "index"
  	 else
  		flash[:warning]='Log in name or password incorrect!'
	    redirect_to :controller => "home", :action => "login"
	end
  end

  def logout
    reset_session
    redirect_to :controller => "home", :action => "login"
  end
end
