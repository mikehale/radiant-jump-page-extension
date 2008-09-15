require 'hpricot'

class JumpPageExtension < Radiant::Extension
  version "1.0"
  description "Provides a 'jump page' for all external links from your radiant site."
  url "http://github.com/mikehale/radiant-jump_page-extension"
  
  define_routes do |map|
    map.connect 'jump/:title/*url', :controller => '/jump_page'
  end
  
  def activate
    Page.send :include, JumpPageTags    
    Page.class_eval do
      
      def parse_object_with_rewrite_links(object)
        text = parse_object_without_rewrite_links(object)
        doc = Hpricot(text)
        
        (doc/"a").each {|link|
          url = link.attributes['href']
          next if self.is_a? JumpPage 
          next if url =~ /^\/.*/ # starts with /

          if jumppage = Page.find_by_class_name("JumpPage")
            link['href'] = "/jump/#{encode(link.inner_html)}/#{url}"
          end
        }
        
        doc.to_html
      end
      alias_method_chain :parse_object, :rewrite_links
      
      def encode(string)
        string.to_a.pack('m').chomp
      end      
      
    end
  end
  
  def deactivate
  end
  
end