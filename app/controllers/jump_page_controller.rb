class JumpPageController < ApplicationController
  session :off
  no_login_required
  skip_before_filter :verify_authenticity_token
  
  def index
    # email_page.request, email_page.response = request, response
    # render :text => email_page.render
    
    render :text => 'from controller'
  end  
end