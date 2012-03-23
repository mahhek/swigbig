require 'test_helper'

class AdminTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
# == Schema Information
#
# Table name: admins
#
#  id                 :integer(4)      not null, primary key
#  email              :string(255)     default(""), not null
#  encrypted_password :string(128)     default(""), not null
#  sign_in_count      :integer(4)      default(0)
#  current_sign_in_at :datetime
#  last_sign_in_at    :datetime
#  current_sign_in_ip :string(255)
#  last_sign_in_ip    :string(255)
#  failed_attempts    :integer(4)      default(0)
#  unlock_token       :string(255)
#  locked_at          :datetime
#  created_at         :datetime
#  updated_at         :datetime
#

