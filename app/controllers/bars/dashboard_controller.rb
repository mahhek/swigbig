class Bars::DashboardController < ApplicationController
  layout 'bars'

  before_filter :authenticate_bar!

  def index
    session[:user_type_login] = nil
    session[:button] = "home"
  end
end
