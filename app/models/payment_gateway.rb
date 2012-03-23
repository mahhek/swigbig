class PaymentGateway < ActiveRecord::Base
  validates :name, :login, :password, :presence => true
end
