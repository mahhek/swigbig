class Admins::DashboardController < ApplicationController
  layout 'admins'
  
  before_filter :authenticate_admin!

  def index
    session[:button] = "home"
  end
end
