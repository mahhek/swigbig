class StatusController < ApplicationController
  before_filter :authenticate_user!

  log_activity_streams :current_user,:full_name, :update_status,:@status,:show_status,
    :create,"update_status"


  def create    
    @status = Status.create(:body => params[:status][:body], :user_id => current_user.id)
    fb_update_status(params[:status][:body])
    #twitter_update_status(params[:status][:body])
    redirect_to :back, notice: 'Status was successfully created.'
  end

  def destroy
    status = Status.find(params[:id])
    status.destroy
    redirect_to :back, notice: 'Status was successfully deleted.'
  end

  def post_comment
    status = Status.find(params[:id])
    status.comments.create(:user_id => params[:user_id], 
      :title => params[:title],
      :comment => params[:comment])

    redirect_to :back, notice: 'Comment was successfully created.'
  end
end
