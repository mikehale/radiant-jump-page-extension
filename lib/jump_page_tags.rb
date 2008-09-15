module JumpPageTags
  include Radiant::Taggable
  
  tag 'jump_page' do |tag|
    tag.expand
  end
  
  desc %{ Renders the original link (<a href="http://example.com">Example</a>) }
  tag 'jump_page:link' do |tag|
    %(<a href='#{find_url(tag)}'>#{find_title(tag)}</a>)
  end
  
  desc %{ Renders the original url (http://example.com) }
  tag 'jump_page:url' do |tag|
    find_url(tag)
  end
  
  desc %{ Renders the original title (Example) }
  tag 'jump_page:title' do |tag|
    find_title(tag)
  end
  
  private
  
  def find_title(tag)
    CGI.unescape(tag.locals.page.last_title)
  end
  
  def find_url(tag)
    tag.locals.page.last_url
  end
    
end
