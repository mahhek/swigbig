class UsersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_user
  
  def show
  end

  private

  def find_user
    @user = User.find(params[:id])
  end

end
