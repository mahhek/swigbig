class Status < ActiveRecord::Base
  acts_as_commentable
  
  belongs_to :user

  def show_status
    self.body
  end
end
# == Schema Information
#
# Table name: status
#
#  id         :integer(4)      not null, primary key
#  user_id    :integer(4)
#  body       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

