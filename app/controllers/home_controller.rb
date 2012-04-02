class HomeController < ApplicationController
  
  def index
    if current_subdomain and current_user
      @bar = Bar.find_by_name(current_subdomain)
      redirect_to "/bar_details"
    else
      redirect_to new_user_session_path
    end
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
