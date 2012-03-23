class UserMailer < ActionMailer::Base
  default from: "from@example.com"


  def invite_user(email, user)
    @user = user    
    mail(:to => "#{email}", :subject => "SwigBig Invitation from #{user.full_name}")
  end

  private

  def setup
    
  end
end
