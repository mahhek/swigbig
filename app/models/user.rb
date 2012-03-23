class User < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, :use => :slugged

  acts_as_messageable :required => [:body, :topic]

  has_attached_file :avatar,
    :styles => { :medium => "300x300>", :thumb => "100x100>" },
    :path => ":rails_root/app/assets/images/system/:attachment/:id/:style/:filename",
    :url => "system/:attachment/:id/:style/:filename",
    :default_url => 'paperclip_missing/profile-default.jpg'

  belongs_to :coupon

  with_options :dependent => :destroy do |user|
    has_many :status
    has_many :swigs
    has_many :rewards, :through => :swigs, :class_name => "UserReward"
    has_many :notifications, :as => :notifiable
    has_many :user_popularities
  end

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable, :omniauthable, :lastseenable,
    :recoverable, :rememberable, :trackable, :validatable, :confirmable, :token_authenticatable

  include Amistad::FriendModel

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name, :address,
    :phone_number, :zip_code, :city, :state_abbr, :country_abbr, :avatar,:service_uid, :id

  #validates :name, :presence => true
  #validates :address, :phone_number, :zip_code, :city, :state_abbr, :country_abbr,
  #  :presence => true, :on => :update

  validates_attachment_size :avatar, :less_than => 1.megabyte
  validates_attachment_content_type :avatar, :content_type=>['image/jpg', 'image/jpeg', 'image/png', 'image/gif']

  scope :excludes, lambda { |ids| where(["id NOT IN (?)", ids]) }

  attr_writer :current_step

  def steps
    %w[basic profile confirmation]
  end

  def current_step
    @current_step || steps.first
  end

  def previous_step
    self.current_step = steps[steps.index(current_step)-1]
  end

  def next_step
    self.current_step = steps[steps.index(current_step)+1]
  end

  def first_step?
    current_step == steps.first
  end

  def last_step?
    current_step == steps.last
  end

  def all_valid?
    steps.all? do |step|
      self.current_step = step
      valid?
    end
  end

  def self.find_for_google_apps_oauth(access_token, signed_in_resource=nil)
    #    v_uid = access_token["uid"]
    v_uid = access_token["uid"].split("?id=").last
    user_info = access_token["user_info"]
    if user = User.find_by_service_uid(v_uid)
      [user, false]
    else # Create a user with a stub password.      
      password_credential = Devise.friendly_token[0,20]
      user = User.new(
        :name => user_info["name"],
        :email => user_info["email"],
        :password => password_credential,
        :service_uid => v_uid)
      #user.skip_confirmation!
      #user.save!
      [user, true]
    end
  end
  
  def self.find_for_facebook_oauth(access_token, signed_in_resource=nil)    
    data = access_token['extra']['user_hash']
    if user = User.find_by_service_uid(access_token["uid"])
      [user, false]
    else # Create a user with a stub password.
      tmp = access_token["uid"]
      password_credential = Devise.friendly_token[0,20]
      user = User.new(
        :name => "fb_user_#{tmp}",
        :email => data["email"],
        :password => password_credential,
        :service_uid => tmp,
        :roles => "user")
      #user.skip_confirmation!
      #user.save!
      [user, true]
    end
  end

  def self.find_for_twitter_oauth(access_token, signed_in_resource=nil)
    if user = User.find_by_service_uid(access_token["uid"])
      [user, false]
    else # Create a user with a stub password.
      password_credential = Devise.friendly_token[0,20]
      user = User.new(:name => "twitter_#{access_token["uid"]}",
        :email => access_token["uid"]+"@swigbig.com",
        :password => password_credential,
        :service_uid => access_token["uid"],
        :roles => "user")
      #user.skip_confirmation!
      #user.save!
      [user, true]
    end
  end

  def state
    state_abbr.nil? ? nil : Carmen::state_name(state_abbr)
  end

  def country
    country_abbr.nil? ? nil : Carmen::country_name(country_abbr)
  end

  def full_name
    self.name
  end

  def has_discount?
    self.coupon.nil? ? false : true
  end

  def is_completed?
    %w( name address phone_number zip_code city state_abbr country_abbr ).each do |key|
      if self.attributes[key].blank?
        return false
      end
    end

    return true
  end

  def complete_registrations
    user = self
    user.confirmation_token = nil
    user.confirmed_at = Time.now
    user.country_abbr = "US"
    user.save
  end
end
# == Schema Information
#
# Table name: users
#
#  id                     :integer(4)      not null, primary key
#  email                  :string(255)     default(""), not null
#  encrypted_password     :string(128)     default("")
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer(4)      default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  authentication_token   :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  avatar_file_name       :string(255)
#  avatar_content_type    :string(255)
#  avatar_file_size       :integer(4)
#  avatar_updated_at      :datetime
#  name                   :string(255)
#  address                :string(255)
#  zip_code               :string(255)
#  phone_number           :string(255)
#  city                   :string(255)
#  state_abbr             :string(255)
#  country_abbr           :string(255)
#  slug                   :string(255)
#  activity_stream_token  :string(255)
#  last_seen              :datetime
#  invitation_token       :string(60)
#  invitation_sent_at     :datetime
#  invitation_accepted_at :datetime
#  invitation_limit       :integer(4)
#  invited_by_id          :integer(4)
#  invited_by_type        :string(255)
#  coupon_id              :integer(4)
#  service_uid            :string(255)
#

