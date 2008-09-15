module JumpPageTags
  include Radiant::Taggable
  
  tag 'jump_page' do |tag|
    tag.expand
  end
  
  tag 'jump_page:link' do |tag|
    %(<a href='#{find_url(tag)}'>#{find_title(tag)}</a>)
  end
  
  tag 'jump_page:url' do |tag|
    find_url(tag)
  end
  
  tag 'jump_page:title' do |tag|
    find_title(tag)
  end
  
  def find_title(tag)
    unpack(tag.locals.page.last_title)
  end
  
  def find_url(tag)
    tag.locals.page.last_url
  end
  
  def unpack(string)
    string.unpack('m').first
  end
  
end
