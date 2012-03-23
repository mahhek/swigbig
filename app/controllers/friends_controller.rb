class FriendsController < ApplicationController
  before_filter :authenticate_user!
  
  before_filter :find_friend, :except => [:index]

  def index
    session[:button] = "friends"
    begin
    @graph = Koala::Facebook::GraphAPI.new(session["fb_oauth"])
    @graph.get_object("me")
    rescue
    end

    @friends = current_user.friends rescue []
    @num_of_friends = @friends.count
    @pending_invited_by = current_user.pending_invited_by
    @num_of_friend_requests = @pending_invited_by.count
    @pending_invited = current_user.pending_invited
    @numb_pending_invited = @pending_invited.count
    ab = current_user.friends(&:id) rescue []
    ids = [current_user.id]  + ab + @pending_invited_by.map(&:id) + @pending_invited.map(&:id)
    @users = User.excludes(ids).paginate :per_page => 20, :page => params[:page]
  end

  def update
    current_user.invite(@friend)
    redirect_to :back
  end

  def approve
    current_user.approve(@friend)    
    redirect_to :back
  end

  def block
    current_user.block(@friend)
    redirect_to :back
  end

  def destroy
    current_user.remove_friendship(@friend)
    redirect_to :back
  end

 

  private

  def find_friend
    @friend = User.find(params[:id])
  end
end
