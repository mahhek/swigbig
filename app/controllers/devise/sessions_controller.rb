class Devise::SessionsController < ApplicationController
  prepend_before_filter :require_no_authentication, :only => [ :new, :create ]
  #before_filter :allow_params_authentication!, :only => :create
  include Devise::Controllers::InternalHelpers
  layout "landing_page", :only => [:new]

  # GET /resource/sign_in
  def new
    session[:user_type_login] = params[:login]
    @bar_deals = BarDeal.where(is_active: true)
    @cities = Bar.select("city").all
    @top_ten_swigs = Swig.get_top_ten_swigers
    if params[:login].eql?("admin")
      respond_to do |format|
        format.js {render :update_admin}
        format.html{}
      end
    elsif params[:login].eql?("user")
      respond_to do |format|
        format.js {render :update_user}
        format.html{}
      end
    elsif params[:login].eql?("bar")
      respond_to do |format|
        format.js {render :update_bar}
        format.html{}
      end
    else
      resource = build_resource
      clean_up_passwords(resource)
      respond_with_navigational(resource, stub_options(resource)){ render_with_scope :new }
    end
  end

  
  #  def new
  #    resource = build_resource
  #    clean_up_passwords(resource)
  #    respond_with_navigational(resource, stub_options(resource)){ render_with_scope :new }
  #  end
  
  # POST /resource/sign_in
  def create
    if params[:user] or params[:admin]
      resource = warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#new")
      set_flash_message(:notice, :signed_in) if is_navigational_format?
      sign_in(resource_name, resource)
      respond_with resource, :location => redirect_location(resource_name, resource)
    elsif params[:bar]
      resource = warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#new")
      set_flash_message(:notice, :signed_in) if is_navigational_format?
      sign_in(resource_name, resource)
      if current_subdomain
      redirect_to "http://#{request.host}:#{request.port}/bar_details?bar_id=#{resource[:id]}"
      else
      redirect_to "http://#{resource[:name]}.#{request.host}:#{request.port}/bar_details?bar_id=#{resource[:id]}"
      end
    end
  end

  # GET /resource/sign_out
  def destroy
    signed_in = signed_in?(resource_name)
    Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
    set_flash_message :notice, :signed_out if signed_in

    # We actually need to hardcode this, as Rails default responder doesn't
    # support returning empty response on GET request
    respond_to do |format|
      format.any(*navigational_formats) { redirect_to after_sign_out_path_for(resource_name) }
      format.all do
        method = "to_#{request_format}"
        text = {}.respond_to?(method) ? {}.send(method) : ""
        render :text => text, :status => :ok
      end
    end
  end

  protected

  def stub_options(resource)
    methods = resource_class.authentication_keys.dup
    methods = methods.keys if methods.is_a?(Hash)
    methods << :password if resource.respond_to?(:password)
    { :methods => methods, :only => [:password] }
  end
end