class JumpPageController < ApplicationController
  session :off
  no_login_required
  skip_before_filter :verify_authenticity_token
  
  def index
    jump_page.request, jump_page.response = request, response
    jump_page.last_url = params[:url]
    jump_page.last_title = params[:title]
    render :text => jump_page.render
  end
  
  private
  def jump_page
    @jump_page ||= Page.find_by_class_name("JumpPage")
  end
  
end