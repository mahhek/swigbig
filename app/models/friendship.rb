class Friendship < ActiveRecord::Base
  include Amistad::FriendshipModel
end
# == Schema Information
#
# Table name: friendships
#
#  id         :integer(4)      not null, primary key
#  user_id    :integer(4)
#  friend_id  :integer(4)
#  blocker_id :integer(4)
#  pending    :boolean(1)      default(TRUE)
#

