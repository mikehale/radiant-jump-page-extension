require File.dirname(__FILE__) + '/../test_helper'

class JumpPageTest < ActionController::IntegrationTest
  
  def setup
    @title = "Google!"
    @url = "http://google.com"
    @escaped_title = CGI.escape(@title)
    @jumppage_url = "/jump/#{@escaped_title}/#{@url}"

    @home = Page.create!(:title => 'Home', 
                         :slug => '/', 
                         :breadcrumb => 'home', 
                         :status => Status[:published])
    PagePart.create!(:name => 'body', :page => @home, :content => home_page)
                     
    @jumppage = Page.create!(:title => 'Jump', 
                             :slug => 'jump', 
                             :breadcrumb => 'jump', 
                             :status => Status[:published], 
                             :parent => @home, 
                             :class_name => "JumpPage")
    PagePart.create!(:name => 'body', :page => @jumppage, :content => jump_page)
  end
      
  def test_rewrites_external_links    
    get '/'
    assert_select "body:first-child a[href=/somepage]"
    assert_select "body:last-child a[href=#{@jumppage_url}]"
  end
  
  def test_tags
    get @jumppage_url
    assert_select "div a[href=#{@url}]", @title
  end
  
  def jump_page
    %(
      <div><r:jump_page:link/></div>
    )
  end
  
  def home_page
    %(<html><body>    
      <a href="/somepage">Local Link</a>
      <a href="#{@url}">#{@title}</a>
    </body></html>)
  end
    
end