class Api::BarsController < ApplicationController
  protect_from_forgery :except => [:search_bars, :request_from_mobile, :complete_register, :invite_user, :bar_directory]

  def bar_directory
    puts params
    bar = Bar.paginate(:page => params[:page], :per_page => 1).where(['status = ?','active'])
    count_bar =  Bar.where(['status = ?','active']).count
    respond_to do |format|
      format.json { render :json => bar.first.attributes.merge(:current_page => params[:page].to_i, :count_bar => count_bar) }
    end
  end
  
  def invite_user
    notifier = User.find(params[:notifier].to_i)
    bar = Bar.find(params[:bar_id].to_i)
    another_users = params[:another_user].split(',')

    another_users.each do |user|
      send_to = User.where("name = ?", user)
      notif = send_to.first.notifications.new(
        notifier_id: notifier.id,
        notifier_type: "User",
        bar_id: bar.id,
        description: "You Was invited by #{notifier.name} on this bar : #{bar.name}"
      )
      notif.save
    end
    respond_to do |format|
      format.json { render :json => "status : success" }
    end
  end
  
  def search_bars
    puts params
    params[:latitude] = "-6.86609".to_f if params[:latitude].to_s.eql?('0.0')
    params[:longitude] = "107.536".to_f if params[:longitude].to_s.eql?('0.0')
    bars = Bar.near([params[:latitude].to_f, params[:longitude].to_f], 15).order(:distance)

    respond_to do |format|
      #format.json  { render :json => ProfileJson.near_bars(bars, params[:latitude], params[:longitude ]) }
      format.json  { render :json => bars }
    end
  end

  def checkin
    puts params
    bar = Bar.find(params[:bar_id])
    if bar
      if bar.qrcode.eql?(params[:qrcode])
        swig = Swig.where(["bar_id = ? AND user_id = ?", bar.id, params[:user_id]])
        #        swig = Swig.find_by_bar_id_and_user_id(bar.id.to_i, params[:user_id].to_i)
        if swig.first
          swig.first.update_swigging
        else
          swig = Swig.create_swigging(params[:user_id], params[:bar_id])
        end
        swig.first.update_status
        swig.first.give_reward
        respond_to do |format|
          format.json { render :json => ProfileJson.notification(bar)}
        end
      else
        respond_to do |format|
          format.json { render :json => "error : wrong qrcode" }
        end
      end
    else
      respond_to do |format|
        format.json { render :json => "error : cant find bar" }
      end
    end
  end

  def profile_user
    user = User.find(params[:id].to_i)
    respond_to do |format|
      format.json  { render :json => ProfileJson.profile_to_json(user) }
    end
  end

  def register_account
    user = User.new(:email => params[:user][:email], :password => params[:user][:password], :password_confirmation => params[:user][:password_confirmation])
    if user.save
      user.complete_registrations
      respond_to do |format|
        format.json  { render :json => ProfileJson.profile_to_json(user) }
      end
    else
      respond_to do |format|
        format.json  { render :json => user.errors.messages.merge(:error => "error") }
      end
    end
  end

  def complete_register
    puts params
    param = params[:blob]
    user_param = {}
    user_param["user"] = {}
    user_param["user"]["avatar"] = params[:avatar]
    array_param = param.split('&')
    array_param.each do |ar|
      if ar.split('=').count.eql?(2)
        if ar.split('=').first.eql?('id_user')
          user_param[ar.split('=').first] = ar.split('=').last
        else
          user_param["user"][ar.split('=').first] = ar.split('=').last
        end
      end
    end
    puts "new = #{user_param}"
    puts params[:avatar].size
    user = User.find(user_param["id_user"].to_i)
    if user.update_attributes(user_param["user"])
      respond_to do |format|
        format.json  { render :json => ProfileJson.profile_to_json(user) }
      end
    else
      respond_to do |format|
        format.json  { render :json => user.errors.messages.merge(:error => "error") }
      end
    end
  end
end
