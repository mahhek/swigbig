class CreditCard < ActiveRecord::Base
  belongs_to :bar

  validates :first_name, :last_name, :number,
    :month, :year, :cvv2, :presence => true
end
# == Schema Information
#
# Table name: credit_cards
#
#  id         :integer(4)      not null, primary key
#  bar_id     :integer(4)
#  first_name :string(255)
#  last_name  :string(255)
#  number     :string(255)
#  month      :integer(4)
#  year       :integer(4)
#  cvv2       :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

