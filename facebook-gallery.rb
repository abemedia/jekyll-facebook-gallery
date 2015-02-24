module Jekyll

  class FacebookAlbum < Page
    def initialize(site, base, dir, name, category, data)
      @site = site
      @base = base
      @dir = dir
      @name = name + '.html'

      self.process(@name)
      
      self.read_yaml(File.join(base, '_layouts'), 'gallery.html')
      
      self.data['title'] = data['title']
      self.data['slug'] = name
      self.data['image'] = data['image']
      self.data['category'] = category
    end
  end
  
  class FacebookPhotosGenerator < Generator
      
    def getdata(path)
      url = "http://graph.facebook.com/#{path}"
      json_data = Net::HTTP.get_response(URI.parse(url)).body
      data = JSON.parse(json_data)
      return data['data'] || data
    end
    
    def generate(site)
      require 'net/http'
      require 'rubygems'
      require 'json'
      
      config = Jekyll.configuration({})
      
      username = config['facebook_gallery']['username'].split("/").last
      
      exclude = config.key?('facebook_gallery') && config['facebook_gallery'].key?('exclude') ? config['facebook_gallery']['exclude'] : ['Timeline Photos', 'Cover Photos', 'Profile Pictures']
      
      albums = getdata(username + '/albums')
      
      for album in albums
        unless !album && (album['count'].nil? || album['count'] == 0) || (exclude.include? album['name'])
          data = Hash.new
          data['id'] = album['id']
          data['title'] = album['name']
          data['count'] = album['count']
          data['image'] = getdata(album['cover_photo'])['source']
          data['link'] = album['id']
          
          photos = getdata(album['id'] + '/photos')
          
          slug = data['title'].downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
          
          for photo in photos
            if photo['id']
              item = Hash.new
              #item['id'] = photo['id']
              item['title'] = photo['name']
              item['image'] = photo['source']
              
              site.pages << FacebookAlbum.new(site, site.source, 'gallery/' + slug, photo['id'], slug, item)
            end
          end
          
          site.pages << FacebookAlbum.new(site, site.source, 'gallery', slug, 'gallery', data)
        end
      end
    end
    
  end
  
end
