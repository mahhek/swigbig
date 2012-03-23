class AccountController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_user
  
  def show
    session[:button] = "my_account"
  end

  def update
    if @user.update_attributes(params[:user])
      redirect_to account_path, :notice => "Your account successfully updated."
    else
      render :edit
    end
  end

  private

  def find_user
    @user = current_user
  end
end
