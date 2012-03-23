class Slogan < ActiveRecord::Base
  validates :title, :presence => true
end
# == Schema Information
#
# Table name: slogans
#
#  id         :integer(4)      not null, primary key
#  title      :string(255)
#  active     :boolean(1)      default(FALSE)
#  created_at :datetime
#  updated_at :datetime
#

