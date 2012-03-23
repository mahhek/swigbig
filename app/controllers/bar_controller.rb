class BarController < ApplicationController
  before_filter :authenticate_user!

  def favourite_bar
    @favourite_bar = Swig.order("reward_point DESC").first
    session[:button] = "favourite"
  end
end
