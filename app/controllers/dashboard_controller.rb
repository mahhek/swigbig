class DashboardController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    session[:user_type_login] = nil
    @status = current_user.status.order("created_at DESC")
    @new_status = Status.new
    session[:button] = "home"
  end

  def invite_friends    
    @graph = Koala::Facebook::GraphAPI.new(session["fb_oauth"])
    unless params[:friends].blank?      
      params[:friends].each do |friend|
        pp @graph.get_object(friend)
        pp "--------------------------"
      end
    end
  end

  def twitter    
    if session[:twitter_user]
      @twitter = get_twitter
      friends = @twitter.friends.users rescue []
      ids = friends.map(&:id) rescue 0
      @users = User.where("service_uid in (?)", ids)
      render :template => 'dashboard/get_friends/twitter'
    else
      redirect_to user_omniauth_authorize_path("twitter")
    end
  end

  def facebook
    if session["fb_oauth"]
      ids = get_facebook_friends_ids
      @users = User.where("service_uid in (?)", ids)
      render :template => 'dashboard/get_friends/facebook'
    else
      redirect_to user_omniauth_authorize_path("facebook")
    end
  end

  def invite
    @user = current_user
    render :template => 'dashboard/get_friends/invite_email'
  end

  def invite_email
    emails = params[:email].split(',')
    emails.each do |email|
      UserMailer.invite_user(email, current_user).deliver
    end

    flash[:notice] = "Succesfully invited .."

    redirect_to :back
  end

  def get_more_friends

  end
end
