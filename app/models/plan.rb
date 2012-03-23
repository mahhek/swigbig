class Plan < ActiveRecord::Base
  has_many :bars, :dependent => :nullify

  validates :name, :price, :description, :presence => true
end
# == Schema Information
#
# Table name: plans
#
#  id          :integer(4)      not null, primary key
#  name        :string(255)
#  price       :float
#  description :text
#  created_at  :datetime
#  updated_at  :datetime
#

