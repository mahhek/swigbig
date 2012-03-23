class MessagesController < ApplicationController
  before_filter :find_message, :only => [:update]
  
  def index
    @messages = current_user.received_messages.paginate :per_page => 20, :page => params[:page]
    session[:button] = "inbox"
  end

  def new
    @receiver = User.find(params[:id])
  end

  def show
    @messages = current_user.messages.with_id(params[:id]).first.conversation
  end

  def create
    @receiver = User.find(params[:id])
    current_user.send_message(@receiver, params[:message])
    redirect_to user_path(@receiver), :notice => "Your message has been sent."
  end

  def update
    current_user.reply_to(@message, "Re: #{@message.topic}", params[:message][:body])
    redirect_to messages_path, :notice => "Your message has been sent."
  end
  
  def destroy
    current_user.messages.with_id(params[:id]).process do |message|
      message.delete
    end
    
    redirect_to messages_path, :notice => "Message was successfully deleted."
  end

  private

  def find_message
    @message = current_user.messages.with_id(params[:id]).first
  end

end
