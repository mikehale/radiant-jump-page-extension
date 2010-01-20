require 'hpricot'

class JumpPageExtension < Radiant::Extension
  version "1.0"
  description "Provides a 'jump page' for all external links from your radiant site."
  url "http://github.com/mikehale/radiant-jump_page-extension"

  define_routes do |map|
    map.connect 'jump/:title/*url', :controller => '/jump_page'
  end

  def activate
    String.class_eval do
      def encode
        self.to_a.pack('m').chomp
      end
    end

    Page.send :include, JumpPageTags
    Page.class_eval do

      def parse_object_with_rewrite_links(object)
        text = parse_object_without_rewrite_links(object)
        return text if (text =~ /<\?xml.*\?>/) # don't do anything if this is an XML document

        doc = Hpricot(text)

        (doc/"a").each {|link|
          url = link.attributes['href']
          next if self.is_a? JumpPage
          next if url =~ /^\/.*/ # starts with /
          next if url =~ /javascript/
          next if url =~ /^#/

          if jumppage = Page.find_by_class_name("JumpPage")
            should_exclude = jumppage.config[:exclude].detect{|e| url =~ /#{Regexp.escape(e)}/ }
            next if should_exclude

            unless link.inner_html.blank? || url.blank?
              link['href'] = "/jump/#{link.inner_html.encode}/#{url.encode}"
            end
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