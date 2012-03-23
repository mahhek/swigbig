class SwigsController < ApplicationController
  before_filter :authenticate_user!, :except => :top_ten_swigers

  def top_ten_swigs
    session[:button] = "top_ten"
    @top_ten_swigs = current_user.swigs.order("reward_point DESC").limit(10)
    respond_to do |format|
      format.js {render :update}
      format.html{}
    end
  end

  def show
    @swig = Swig.find params[:id]
  end

  def top_ten_swigers
    @top_ten_swigs = Swig.get_top_ten_swigers
    respond_to do |format|
      format.js {render :update_checkin_history}
      format.html{}
    end
  end

  
end
