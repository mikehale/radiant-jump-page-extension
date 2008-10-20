require File.dirname(__FILE__) + '/../test_helper'

class JumpPageTest < ActionController::IntegrationTest
  
  def setup
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
    PagePart.create!(:name => 'config', :page => @jumppage, :content => jump_page_config)
  end
        
  def test_rewrites_external_links    
    get '/'
    assert_select "a[href=/somepage]"
    assert_select "a[href=javascript:void(0);]"
    assert_select "a[href=no_name]"
    assert_select "a[name=no_href]"
    assert_select "a[href=#]"
    assert_select "a[href=http://news.google.com]"
    assert_select "a[href=/jump/#{"Google!".encode}/#{"http://google.com".encode}]"
  end
  
  def test_tags
    title = "Google!"
    url = "http://google.com"
    get "/jump/#{title.encode}/#{url.encode}"
    assert_select "div a[href=#{url}]", title

    title = "Link with params"
    url = "http://www.google.com/search?q=test"
    get "/jump/#{title.encode}/#{url.encode}"
    assert_select "div a[href=#{url}]", title
  end
  
  def jump_page
    %(
      <div><r:jump_page:link/></div>
    )
  end
  
  def jump_page_config
    %(
    exclude:
      - http://news.google.com
    )
  end
  
  def home_page
    %(<html><body>    
      <a href="/somepage">Local Link</a>
      <a href="javascript:void(0);">Javascript Action</a>
      <a href="no_name"></a>
      <a name="no_href"></a>
      <a href="#">Local Link</a>
      <a name="remote_link" href="http://google.com#">Remote Link</a>
      <a href="http://news.google.com">Google News</a>
      <a href="http://google.com">Google!</a>
      <a href="http://www.google.com/search?q=test">Link with query param</a>
    </body></html>)
  end
    
end