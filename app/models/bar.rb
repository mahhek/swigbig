class Bar < ActiveRecord::Base
  include AASM
  
  extend FriendlyId
  friendly_id :name, :use => :slugged

  acts_as_gmappable :process_geocoding => false

  geocoded_by :address

  has_attached_file :logo,
    :path => ":rails_root/app/assets/system/:attachment/:id/:style/:filename",
    :url => "system/:attachment/:id/:style/:filename",
    :default_url => 'paperclip_missing/logo-default.jpg',
    :styles => { :medium => "300x300>", :thumb => "100x100>" }

  belongs_to :plan

  with_options :dependent => :destroy do |bar|
    bar.has_many :swigs
    bar.has_many :bar_deals
    bar.has_many :bar_rewards
    bar.has_many :notifications
    bar.has_many :user_popularities
    bar.has_one :credit_card
  end

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable,
    :confirmable, :token_authenticatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name, :address,
    :phone_number, :zip_code, :city, :state_abbr, :country_abbr, :logo, :id, :latitude,
    :longitude, :service_uid

  validates :name, :presence => true, :if => lambda { |o| o.current_step == "profile" }
  #  validates :address, :phone_number, :zip_code, :city, :state_abbr, :country_abbr,
  #    :latitude, :longitude, :presence => true, :if => lambda { |o| o.current_step == "profile" } #, :on => :update

  validates_attachment_size :logo, :less_than => 1.megabyte
  validates_attachment_content_type :logo, :content_type=>['image/jpg', 'image/jpeg', 'image/png', 'image/gif']

  aasm_column :status
  aasm_initial_state :inactive

  aasm_state :inactive
  aasm_state :active

  aasm_event :activate do
    transitions :to => :active, :from => [:inactive]
  end

  aasm_event :deactivate do
    transitions :to => :inactive, :from => [:active]
  end

  attr_writer :current_step

  def self.find_for_google_apps_oauth(access_token, signed_in_resource=nil)
    #    v_uid = access_token["uid"]
    v_uid = access_token["uid"].split("?id=").last
    user_info = access_token["user_info"]
    if user = Bar.find_by_service_uid(v_uid)
      [user, false]
    else # Create a user with a stub password.
      password_credential = Devise.friendly_token[0,20]
      user = Bar.new(
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
    if user = Bar.find_by_service_uid(access_token["uid"])
      [user, false]
    else # Create a user with a stub password.
      tmp = access_token["uid"]
      password_credential = Devise.friendly_token[0,20]
      user = Bar.new(
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
    if user = Bar.find_by_service_uid(access_token["uid"])
      [user, false]
    else # Create a user with a stub password.
      password_credential = Devise.friendly_token[0,20]
      user = Bar.new(:name => "twitter_#{access_token["uid"]}",
        :email => access_token["uid"]+"@swigbig.com",
        :password => password_credential,
        :service_uid => access_token["uid"],
        :roles => "user")
      #user.skip_confirmation!
      #user.save!
      [user, true]
    end
  end

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

  def gmaps4rails_address
    "#{self.address}, #{self.city}, #{self.country}"
  end

  def gmaps4rails_infowindow
    "<img src='#{self.logo.url(:thumb)}' /> <br /> #{self.name}'s Bar <br /> #{self.address} - #{self.zip_code}, #{self.city}, #{self.country}"
  end

  def gmaps4rails_title
    self.name
  end

  def gmaps4rails_marker_picture
    {
      #      "picture" => "", # string, mandatory
      #      "width" =>  ,          # string, mandatory
      #      "height" => ,          # string, mandatory
      #      "marker_anchor" => ,   # array, facultative
      #      "shadow_picture" => ,  # string, facultative
      #      "shadow_width" => ,    # string, facultative
      #      "shadow_height" => ,   # string, facultative
      #      "shadow_anchor" => ,   # string, facultative
      #      "rich_marker" =>   ,   # html, facultative
      # If used, all other attributes skipped except "marker_anchor". This array is used as follows:
      # [ anchor , flat ] : flat is a boolean, anchor is an int.
      # See doc here: http://google-maps-utility-library-v3.googlecode.com/svn/trunk/richmarker/docs/reference.html
    }
  end

  def state
    state_abbr.nil? ? nil : Carmen::state_name(state_abbr)
  end

  def country
    country_abbr.nil? ? nil : Carmen::country_name(country_abbr)
  end

  def is_completed?
    %w( name address phone_number zip_code city state_abbr country_abbr latitude longitude logo_file_name).each do |key|
      if self.attributes[key].blank?
        return false
      end
    end

    return true
  end

end
# == Schema Information
#
# Table name: bars
#
#  id                     :integer(4)      not null, primary key
#  email                  :string(255)     default(""), not null
#  encrypted_password     :string(128)     default(""), not null
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
#  name                   :string(255)
#  address                :string(255)
#  zip_code               :string(255)
#  phone_number           :string(255)
#  city                   :string(255)
#  state_abbr             :string(255)
#  country_abbr           :string(255)
#  latitude               :float
#  longitude              :float
#  logo_file_name         :string(255)
#  logo_content_type      :string(255)
#  logo_file_size         :integer(4)
#  logo_updated_at        :datetime
#  slug                   :string(255)
#  gmaps                  :boolean(1)
#  status                 :string(255)     default("inactive")
#  qrcode                 :string(255)
#  plan_id                :integer(4)
#

