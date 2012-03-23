class ApplicationController < ActionController::Base
  helper :layout
  
  include LogActivityStreams
  
  protect_from_forgery

  before_filter :get_active_logo_and_slogan
  before_filter :get_twitter

  def fb_update_status(status)
    begin            
      @graph = Koala::Facebook::GraphAPI.new(session["fb_oauth"])
      @graph.put_wall_post("#{status}")
      return true
    rescue
      return false
    end
    ## the doc
    # https://github.com/arsduo/koala/wiki/Graph-API
    ##
  end

  def facebook_friends
    unless session["fb_oauth"].blank?
      @graph = Koala::Facebook::GraphAPI.new(session["fb_oauth"])
      @friends = @graph.get_connections("me", "friends")
    end
  end

  def get_facebook_friends_ids
    friend_ids = []    
    facebook_friends.each do |fb_friend|
      friend_ids << fb_friend["id"]
    end
        
    return friend_ids
  end

  def facebook_friends_ids
    session[:friend_ids] ||= get_facebook_friends_ids
  end

  def twitter_update_status(status)
    get_twitter
    @twitter.update("#{status}")
  end

  def get_latest_tweet(user)
    get_twitter
    return @twitter.user_timeline(user).first.text
  end

  def facebook
    if session[:user_type_login].eql?("user")
      @user, session[:new_register] = User.find_for_facebook_oauth(env["omniauth.auth"], current_user)
    else
      @user, session[:new_register] = Bar.find_for_facebook_oauth(env["omniauth.auth"], current_bar)
    end
   
    session["devise.facebook_data"] = env["omniauth.auth"]
    session["fb_oauth"] = session["devise.facebook_data"]["credentials"]["token"]
    session[:fb_uid] = env["omniauth.auth"]["uid"]
    
    if session[:new_register]
      flash[:notice] = "Please Insert Your data for complete your profile via facebook"
      if session[:user_type_login].eql?("user")
        session[:user_type_login] = nil
        return redirect_to '/users/sign_up'
      else
        session[:user_type_login] = nil
        return redirect_to '/bars/sign_up'
      end
    end
    
    if @user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Facebook"
      sign_in @user
      redirect_to user_root_url if session[:user_type_login].eql?("user")
      redirect_to bar_root_url if session[:user_type_login].eql?("bar")
    else
      session["devise.facebook_data"] = env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end
  
  #  def google
  #    if params[:user_type_login].eql?("user")
  #      @user, session[:new_register] = User.find_for_google_apps_oauth(env["omniauth.auth"], current_user)
  #    else
  #      @user, session[:new_register] = Bar.find_for_google_apps_oauth(env["omniauth.auth"], current_bar)
  #    end
  #    session[:google_user] = env["omniauth.auth"]["user_info"]
  #    session[:google_email] = env["omniauth.auth"]["email"]
  #    if @user.persisted?
  #      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Google Apps"
  #      sign_in @user
  #
  #      if !session[:new_register]
  #        redirect_to user_root_url if params[:user_type_login].eql?("user")
  #        redirect_to bar_root_url if params[:user_type_login].eql?("bar")
  #      else
  #        flash[:notice] = "Please Insert Your data for complete your profile via Google"
  #        if params[:user_type_login].eql?("user")
  #          session[:user_type_login] = nil
  #          return redirect_to '/users/sign_up'
  #        else
  #          session[:user_type_login] = nil
  #          return redirect_to '/bars/sign_up'
  #        end
  #      end
  #    else
  #      #flash[:notice] = "Please Insert Your data for complete your profile via Google"
  #      session["devise.google_apps_data"] = env["omniauth.auth"]
  #      #redirect_to new_user_registration_url
  #      flash[:notice] = "Please Insert Your data for complete your profile via Google"
  #      if params[:user_type_login].eql?("user")
  #        session[:user_type_login] = nil
  #        return redirect_to '/users/sign_up'
  #      else
  #        session[:user_type_login] = nil
  #        return redirect_to '/bars/sign_up'
  #      end
  #    end
  #
  #  end

  def google
    if params[:user_type_login].eql?("user")
      @user, session[:new_register] = User.find_for_google_apps_oauth(env["omniauth.auth"], current_user)
    else
      @user, session[:new_register] = Bar.find_for_google_apps_oauth(env["omniauth.auth"], current_bar)
    end
    session[:google_user] = env["omniauth.auth"]["user_info"]
    session[:google_email] = env["omniauth.auth"]["email"]
    v_uid = env["omniauth.auth"]["uid"].split("?id=").last
    session[:google_uid] = v_uid

    if session[:new_register]
      flash[:notice] = "Please Insert Your data for complete your profile via Google"
      if params[:user_type_login].eql?("user")
        session[:user_type_login] = nil
        return redirect_to '/users/sign_up'
      else
        session[:user_type_login] = nil
        return redirect_to '/bars/sign_up'
      end
    end

    if @user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Google Apps"
      sign_in @user
      redirect_to user_root_url if params[:user_type_login].eql?("user")
      redirect_to bar_root_url if params[:user_type_login].eql?("bar")
    else
      session["devise.google_apps_data"] = env["omniauth.auth"]
      if params[:user_type_login].eql?("user")
        session[:user_type_login] = nil
        return redirect_to '/users/sign_up'
      else
        session[:user_type_login] = nil
        return redirect_to '/bars/sign_up'
      end
    end

  end

  def twitter
    if session[:user_type_login].eql?("user")
      @user, session[:new_register] = User.find_for_twitter_oauth(env["omniauth.auth"], current_user)
    else
      @user, session[:new_register] = Bar.find_for_twitter_oauth(env["omniauth.auth"], current_bar)
    end
    
    session[:twitter_user] = env["omniauth.auth"]["user_info"]
    session[:twitter_oauth] = env["omniauth.auth"]["credentials"]["token"]
    session[:twitter_secret] = env["omniauth.auth"]["credentials"]["secret"]
    session[:twitter_uid] = env["omniauth.auth"]["uid"]
    
    if session[:new_register]
      flash[:notice] = "Please Insert Your data for complete your profile via twitter"
      if session[:user_type_login].eql?("user")
        session[:user_type_login] = nil
        return redirect_to '/users/sign_up'
      else
        session[:user_type_login] = nil
        return redirect_to '/bars/sign_up'
      end
    end

    if @user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Twitter"      
      sign_in @user
      redirect_to user_root_url if session[:user_type_login].eql?("user")
      redirect_to bar_root_url if session[:user_type_login].eql?("bar")
    else
      session["devise.twitter_data"] = env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

  def get_twitter
    @twitter = Twitter.new
    @twitter.consumer_key = "ljTiP8tlNC2VjKIzQsP4g"
    @twitter.consumer_secret = "S8lx1slu56Wr3LscMdBNfqtygvRfxLhLsIjFQa1M2EA"
    @twitter.oauth_token = session[:twitter_oauth]
    @twitter.oauth_token_secret = session[:twitter_secret]
    @twitter
  end

  def is_social?
    current_user.service_uid
  end

  helper_method :is_social?,:facebook_friends,:facebook_friends_ids,:get_twitter

  protected

  def get_active_logo_and_slogan
    @current_logo = Logo.where(active: true).first
    @current_slogan = Slogan.where(active: true).first
  end
   
end
