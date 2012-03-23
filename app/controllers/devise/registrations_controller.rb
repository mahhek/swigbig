class Devise::RegistrationsController < ApplicationController
  prepend_before_filter :require_no_authentication, :only => [ :new, :create, :cancel ]
  prepend_before_filter :authenticate_scope!, :only => [:edit, :update, :destroy]
  include Devise::Controllers::InternalHelpers
  layout "sign_up", :only => [:new, :create, :edit, :update]
  
  #layout "bars", :only => [:edit, :update]
  #layout "application", :only => [:edit, :update]
  
  # GET /resource/sign_up
  def new
    session[:user_type_login] = params[:login]
    if params[:login].eql?("admin")
      session[:params] ||= {}
      resource = build_resource(session[:params])
      resource.current_step = session[:step]
    
      respond_to do |format|
        format.js {render :update_admin}
        format.html{}
      end
    elsif params[:login].eql?("user")
      session[:params] ||= {}
      resource = build_resource(session[:params])
      resource.current_step = session[:step]
    
      respond_to do |format|
        format.js {render :update_user}
        format.html{}
      end
    elsif params[:login].eql?("bar")
      session[:params] ||= {}
      resource = build_resource(session[:params])
      resource.current_step = session[:step]
    
      respond_to do |format|
        format.js {render :update_bar}
        format.html{}
      end    
    else      
      session[:params] ||= {}
      resource = build_resource(session[:params])
      resource.current_step = session[:step]
    
      respond_with_navigational(resource){ render_with_scope :new }
    end
  end

  # POST /resource
  def create
    key = params.has_key?(:user) ? :user : :bar
    begin
      session[:params].deep_merge!(params[key]) if params[key]
    rescue
      {}.deep_merge!(params[key]) if params[key]
    end
    resource = build_resource(session[:params])
    resource.current_step = session[:step]

    if resource.valid?
      if params[:back_button]
        resource.previous_step
      elsif resource.last_step?
        resource.save
      else
        resource.next_step
      end
      session[:step] = resource.current_step
    end

    if resource.new_record?
      respond_with_navigational(resource) { render_with_scope :new }
    else
      session[:step] = session[:params] = {}
      set_flash_message :notice, :inactive_signed_up, :reason => inactive_reason(resource) if is_navigational_format?
      expire_session_data_after_sign_in!
      respond_with resource, :location => after_inactive_sign_up_path_for(resource)
    end

    #    build_resource
    #    if resource.save
    #      if resource.active_for_authentication?
    #        set_flash_message :notice, :signed_up if is_navigational_format?
    #        sign_in(resource_name, resource)
    #        redirect_to user_root_url
    #        #redirect_to edit_user_url(current_user)
    #        #respond_with resource, :location => redirect_location(resource_name, resource)
    #      else
    #        set_flash_message :notice, :inactive_signed_up, :reason => inactive_reason(resource) if is_navigational_format?
    #        expire_session_data_after_sign_in!
    #        respond_with resource, :location => after_inactive_sign_up_path_for(resource)
    #      end
    #    else
    #      clean_up_passwords(resource)
    #      respond_with_navigational(resource) { render_with_scope :new }
    #    end
  end

  # GET /resource/edit
  def edit
    render_with_scope :edit    
  end

  # PUT /resource
  # We need to use a copy of the resource because we don't want to change
  # the current user in place.
  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)

    if resource.update_with_password(params[resource_name])
      set_flash_message :notice, :updated if is_navigational_format?
      sign_in resource_name, resource, :bypass => true
      respond_with resource, :location => after_update_path_for(resource)
    else
      clean_up_passwords(resource)
      respond_with_navigational(resource){ render_with_scope :edit }
    end
  end

  # DELETE /resource
  def destroy
    resource.destroy
    Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
    set_flash_message :notice, :destroyed if is_navigational_format?
    respond_with_navigational(resource){ redirect_to after_sign_out_path_for(resource_name) }
  end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  def cancel
    expire_session_data_after_sign_in!
    redirect_to new_registration_path(resource_name)
  end

  protected

  # Build a devise resource passing in the session. Useful to move
  # temporary session data to the newly created user.
  def build_resource(hash=nil)
    hash ||= params[resource_name] || {}
    self.resource = resource_class.new_with_session(hash, session)
  end

  # The path used after sign up. You need to overwrite this method
  # in your own RegistrationsController.
  def after_sign_up_path_for(resource)
    after_sign_in_path_for(resource)
  end

  # Overwrite redirect_for_sign_in so it takes uses after_sign_up_path_for.
  def redirect_location(scope, resource)
    stored_location_for(scope) || after_sign_up_path_for(resource)
  end

  # Returns the inactive reason translated.
  def inactive_reason(resource)
    reason = resource.inactive_message.to_s
    I18n.t("devise.registrations.reasons.#{reason}", :default => reason)
  end

  # The path used after sign up for inactive accounts. You need to overwrite
  # this method in your own RegistrationsController.
  def after_inactive_sign_up_path_for(resource)
    root_path
  end

  # The default url to be used after updating a resource. You need to overwrite
  # this method in your own RegistrationsController.
  def after_update_path_for(resource)
    if defined?(super)
      ActiveSupport::Deprecation.warn "Defining after_update_path_for in ApplicationController " <<
        "is deprecated. Please add a RegistrationsController to your application and define it there."
      super
    else
      after_sign_in_path_for(resource)
    end
  end

  # Authenticates the current scope and gets the current resource from the session.
  def authenticate_scope!
    send(:"authenticate_#{resource_name}!", true)
    self.resource = send(:"current_#{resource_name}")
  end
  
  protected

      # Render a view for the specified scope. Turned off by default.
      # Accepts just :controller as option.
      def render_with_scope(action, path=self.controller_path)
        require 'pp'
        pp devise_mapping.scoped_path
        layout = "bars"
        if devise_mapping.scoped_path == "users"
          layout = 'application'
        end
        if self.class.scoped_views?
          begin
            render :template => "#{devise_mapping.scoped_path}/#{path.split("/").last}/#{action}"#, :layout => layout
          rescue ActionView::MissingTemplate
            render :template => "#{path}/#{action}"
          end
        else
          render :template => "#{path}/#{action}"
        end
      end
    

end