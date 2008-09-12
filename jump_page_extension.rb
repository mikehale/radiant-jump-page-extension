require 'hpricot'

class JumpPageExtension < Radiant::Extension
  version "1.0"
  description "Provides a 'jump page' for all external links from your radiant site."
  url "http://github.com/mikehale/radiant-jump_page-extension"
  
  def activate
    Page.class_eval do
      
      def parse_object_with_rewrite_links(object)
        text = parse_object_without_rewrite_links(object)
        doc = Hpricot(text)
        
        (doc/"a").each {|link|
          url = link.attributes['href']
          next if url.include?(request.headers["HTTP_HOST"])

          if jumppage = Page.find_by_class_name("JumpPage")
            link['href'] = "#{jumppage.url}#{CGI::escape(url)}"
          end
        }
        
        doc.to_html
      end
      alias_method_chain :parse_object, :rewrite_links
      
    end
  end
  
  def deactivate
  end
  
end