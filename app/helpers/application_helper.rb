module ApplicationHelper
  
  def show_field_value(object, field_name)
    object.instance_eval(field_name) if object
  end

  def social_user
    user = if is_facebook?
      fb_user
    elsif is_twitter?
      twitter_user
    elsif is_google?
      google_user
    else
      nil
    end
    user
  end

  def social_email
    begin
      email = if is_facebook?
        fb_email
      elsif is_twitter?
        "#{twitter_user}@swigbig.com"
      elsif is_google?
        google_email
      else
        nil
      end
      email
    rescue
      nil
    end
  end

  def service_uid
    uid = if is_facebook?
      session[:fb_uid]       
    elsif is_twitter?
      session[:twitter_uid]
    else
      session[:google_uid]
    end
    uid
  end
  
  def fb_user_swig_big(fb_ids)
    return User.where("service_uid in (?)",fb_ids)
  end

  def get_profile(id)
    @graph = Koala::Facebook::GraphAPI.new(session["fb_oauth"])
    @graph.get_object(id)
  end


  private

  def is_google?
    session["devise.google_apps_data"]
  end

  def is_facebook?
    session[:fb_uid] #session["devise.facebook_data"]
  end

  def is_twitter?
    session[:twitter_user]
  end

  def fb_user
    session["devise.facebook_data"]["user_info"]["name"]
  end

  def google_user
    session[:google_user]["name"]
  end
  
  def twitter_user
    session[:twitter_user]["name"].gsub(' ','_')
  end

  def google_email
    session[:google_user]["email"]
  end
  
  def fb_email
    session["devise.facebook_data"]["user_info"]["email"]
  end 
end
