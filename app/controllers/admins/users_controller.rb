class Admins::UsersController < ApplicationController
  layout 'admins'

  before_filter :authenticate_admin!
  
  before_filter :find_user, :except => [:index, :new, :create]
  
  def index
    @users = User.all
    session[:button] = "user"
  end

  def show
  end

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new(params[:user])

    if @user.save
      redirect_to admins_user_path(@user), notice: 'User was successfully created.'
    else
      render action: "new"
    end
  end

  def update
    if @user.update_attributes(params[:user])
      redirect_to admins_user_path(@user), notice: 'User was successfully updated.'
    else
      render action: "edit"
    end
  end

  def destroy
    @user.destroy
    redirect_to admins_bars_url
  end

  private

  def find_user
    @user = User.find(params[:id])
  end
end
