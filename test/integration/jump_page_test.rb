require File.dirname(__FILE__) + '/../test_helper'

class JumpPageTest < ActionController::IntegrationTest
    
  def test_rewrites_external_links
    home = Page.create!(:title => 'Home', 
                         :slug => '/', 
                         :breadcrumb => 'home', 
                         :status => Status[:published])
    PagePart.create!(:name => 'body', :page => home, :content => content)
                     
    jumppage = Page.create!(:title => 'Jump', 
                             :slug => 'jump', 
                             :breadcrumb => 'jump', 
                             :status => Status[:published], 
                             :parent => home, 
                             :class_name => "JumpPage")
    
    get '/'
    assert_select "body:first-child a[href=/somepage]"
    assert_select "body:last-child a[href=/jump/#{CGI::escape("http://google.com".to_a.pack('m'))}]"
  end
  
  def content
    %(<html><body>    
      <a href="/somepage">Local Link</a>
      <a href="http://google.com">Remote Link</a>
    </body></html>)
  end
    
end