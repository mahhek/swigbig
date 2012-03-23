# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.destroy_all
user = User.create(email: "mahhek@example.org", password: "123456", password_confirmation: "123456",
  name: "mahhek", address: "some street", zip_code: "45201", city: "some city", state_abbr: "OH",
  country_abbr: "US", phone_number: "123456789");

user.confirm!

Bar.destroy_all
bar = Bar.create(email: "hami@example.org", password: "123456", password_confirmation: "123456",
  name: "hami", address: "some street", zip_code: "45021", city: "some city", state_abbr: "OH",
  country_abbr: "US", latitude: 40.7144, longitude: -74.006, phone_number: "123456789")

bar.confirm!
bar.activate!

Admin.delete_all
admin = Admin.create(email: "admin@swigbig.com", password: "123456", password_confirmation: "123456")

Status.delete_all
status = user.status.create(body: "Hello World, this is my first status ;)")

Comment.delete_all
status.comments.create(:user_id => user.id, title: "This is comment title", comment: "Hey there...")

Deal.delete_all
5.times do |i|
  Deal.create(name: "Deal ##{i+1}", tier: i+1, tipping_points: i+3, day_of_week: i+2, is_admin: true)
end

Plan.delete_all
3.times do |i|
  Plan.create(name: "Plan ##{i+1}", price: (i+1)*100, description: "Lorem Ipsum blablabla...")
end

Slogan.delete_all
Slogan.create(:title => "The more people swigging, the better the deal.", active: true)
Slogan.create(:title => "Lorem ipsum dolor sit amet, consectetur adipisicing elit.")

DealType.delete_all
DealType.create(:name => "Standard")
DealType.create(:name => "Big")
RewardType.delete_all
RewardType.create(:name => "Loyalty")
RewardType.create(:name => "Popularity")

PaymentGateway.delete_all
PaymentGateway.create(name: "Paypal", status: true, login: "paypal@swigbig.com", password: "psstsecret", signature: "abc123")
PaymentGateway.create(name: "AuthorizeNet", login: "authorizenet@swigbig.com", password: "psstsecret")
PaymentGateway.create(name: "TrustCommerce", login: "trustcommerce@swigbig.com", password: "psstsecret")

RewardClass.delete_all
RewardClass.create(name: "Loyalty")
RewardClass.create(name: "Popularity")
