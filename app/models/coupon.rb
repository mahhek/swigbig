class Coupon < ActiveRecord::Base
  validates :code, :presence => true
  has_one :user, :dependent => :nullify
end
# == Schema Information
#
# Table name: coupons
#
#  id          :integer(4)      not null, primary key
#  code        :string(255)
#  expire_date :date
#  created_at  :datetime
#  updated_at  :datetime
#

