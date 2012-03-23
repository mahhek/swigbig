class Bars::SettingsController < ApplicationController
  layout 'bars'

  before_filter :authenticate_bar!

  def index
    session[:button] = "setting"
  end
  
  def generate_qrcode
    require 'prawn/qrcode'
    
    qrcode_content = Devise.friendly_token[0,20]
    current_bar.update_attribute(:qrcode, qrcode_content)
    qrcode = RQRCode::QRCode.new(qrcode_content, :level=>:h, :size => 10)

    Prawn::Document.generate('generate_qrcode.pdf') do |pdf|
      pdf.render_qr_code(qrcode, :align=> :center, :dot=> 5, :stroke=> 3 )
      pdf.text "www.swigBIG.com", :align=> :center
    end
    send_file "generate_qrcode.pdf"
  end
  
  def generate_qrcode_poster_1
    require 'prawn/qrcode'

    qrcode_content = Devise.friendly_token[0,20]
    current_bar.update_attribute(:qrcode, qrcode_content)
    qrcode = RQRCode::QRCode.new(qrcode_content, :level=>:h, :size => 10)

    Prawn::Document.generate('generate_qrcode.pdf', :page_size => [344, 444], :background => "#{Rails.root.to_s}/public/images/generate_poster_1.png", :margin => [50, 50, 50, 50] ) do |pdf|
      pdf.render_qr_code(qrcode, :dot=> 3, :align=> :center)
    end
    send_file "generate_qrcode.pdf"
  end
  
  def generate_qrcode_poster_2
    require 'prawn/qrcode'

    qrcode_content = Devise.friendly_token[0,20]
    current_bar.update_attribute(:qrcode, qrcode_content)
    qrcode = RQRCode::QRCode.new(qrcode_content, :level=>:h, :size => 10)

    Prawn::Document.generate('generate_qrcode.pdf', :page_size => [344, 444], :background => "#{Rails.root.to_s}/public/images/generate_poster_2.png", :margin => [50, 50, 50, 50] ) do |pdf|
      pdf.render_qr_code(qrcode, :dot=> 3, :align=> :center)
    end
    send_file "generate_qrcode.pdf"
  end
  
  def generate_qrcode_poster_3
    require 'prawn/qrcode'

    qrcode_content = Devise.friendly_token[0,20]
    current_bar.update_attribute(:qrcode, qrcode_content)
    qrcode = RQRCode::QRCode.new(qrcode_content, :level=>:h, :size => 10)

    Prawn::Document.generate('generate_qrcode.pdf', :page_size => [344, 444], :background => "#{Rails.root.to_s}/public/images/generate_poster_3.png", :margin => [50, 50, 50, 50] ) do |pdf|
      pdf.render_qr_code(qrcode, :dot=> 3, :align=> :center)
    end
    send_file "generate_qrcode.pdf"
  end

end
