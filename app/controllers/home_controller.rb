class HomeController < ApplicationController
  
  def index
    redirect_to new_user_session_path
  end

  def faq
    session[:button] = "faq"
    if bar_signed_in?
      render :layout => "bars"
    elsif user_signed_in?
      render :layout => "application"
    elsif admin_signed_in?
      render :layout => "admins"
    end
  end

  def contact
    session[:button] = "contact"
    if bar_signed_in?
      render :layout => "bars"
    elsif user_signed_in?
      render :layout => "application"
    elsif admin_signed_in?
      render :layout => "admins"
    end
  end

  def bars
    session[:button] = "bars"
    @bars = Bar.active.order(:name).paginate :per_page => 20, :page => params[:page]
    if bar_signed_in?
      render :layout => "bars"
    elsif user_signed_in?
      render :layout => "application"
    elsif admin_signed_in?
      render :layout => "admins"
    end
  end
end
