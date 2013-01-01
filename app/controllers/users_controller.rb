class UsersController < ApplicationController

  before_filter :check_admin
  before_filter :action_name

  # layout change
  # layout :resolve_layout

  # GET /users
  # GET /users.json
  def index
    @users = User.includes(:type).all
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.json
  def create
    params[:user][:password] = Digest::MD5.hexdigest(params[:user][:password])

    @user = User.new(params[:user])

    if @user.save
      redirect_to @user, notice: 'User was successfully created.'
    else
      render action: "new"
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])

    params[:user][:password] = Digest::MD5.hexdigest(params[:user][:password]) if !params[:user][:password].nil?

    if @user.update_attributes(params[:user])
      redirect_to @user, notice: 'User was successfully updated.'
    else
      render action: "edit"
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    redirect_to users_url
  end

  private

  def check_admin
    if current_user[:type_id] == 2
      return true
    else
      redirect_to :controller => 'home', :action => 'index'
      return false
    end
  end

  # def resolve_layout
  #   case action_name
  #   when "new"
  #     "login"
  #   else
  #     "application"
  #   end
  # end
end
