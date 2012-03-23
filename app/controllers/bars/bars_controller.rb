class Bars::BarsController < ApplicationController
  layout 'bars'
  
  before_filter :authenticate_bar!
  
  def show
    @bar = current_bar
    @json = @bar.to_gmaps4rails
    session[:button] = "profile"
  end

end
