class Logo < ActiveRecord::Base
  has_attached_file :image,
    :path => ":rails_root/app/assets/images/system/:attachment/:id/:style/:filename",
    :url => "system/:attachment/:id/:style/:filename",
    :default_url => 'paperclip_missing/logo-default.jpg',
    :styles => { :medium => "300x300>", :thumb => "100x100>" }

  validates :name, :presence => true

  validates_attachment_presence :image
  validates_attachment_size :image, :less_than => 1.megabyte
  validates_attachment_content_type :image, :content_type=>['image/jpg', 'image/jpeg', 'image/png', 'image/gif']
end
# == Schema Information
#
# Table name: logos
#
#  id                 :integer(4)      not null, primary key
#  active             :boolean(1)      default(FALSE)
#  image_file_name    :string(255)
#  image_content_type :string(255)
#  image_file_size    :integer(4)
#  image_updated_at   :datetime
#  created_at         :datetime
#  updated_at         :datetime
#  name               :string(255)
#

