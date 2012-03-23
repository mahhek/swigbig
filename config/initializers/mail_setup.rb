#ActionMailer::Base.smtp_settings = {
#  :address              => "smtp.gmail.com",
#  :port                 => 587,
#  :domain               => "google.com",
#  :user_name            => "donotreplyswigbig@gmail.com",
#  :password             => "gbkw2pshZ3iapB5X7zzq",
#  :authentication       => "plain",
#  :enable_starttls_auto => true
#}

ActionMailer::Base.smtp_settings = {
  :address              => "smtp.gmail.com",
  :port                 => 587,
  :domain               => 'gmail.com',
  :user_name            => 'dummy@41studio.com',
  :password             => 'ssstsecret',
  :authentication       => 'plain',
  :enable_starttls_auto => true
}