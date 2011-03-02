require 'rubygems'
gem 'rack', '~> 1.1.0'
require 'sinatra'
require 'public/7digital/lib/sevendigital'
require 'net/http'
require 'xmlsimple'
require 'haml'

class VerySimpleCache < Hash
  def set(key, value) store(key, value);  end
  def get(key) has_key?(key) ? fetch(key) : nil;  end
end

country = "GB"

def track_list_string track_list, key_param
		track_list_js_string = ""  
		track_list.each do |track|
		url = "#{track.preview_url}#{key_param}&redirect=false"
		url_parse = URI.parse(url)
		print = Net::HTTP.get_response(url_parse)

		api_response = print.body
		data = XmlSimple.xml_in(api_response)

		track_list_js_string = track_list_js_string + "{name:\"#{track.artist.name}-#{track.title}\",mp3:\" #{data['url']}\"},"
	end
  
	return "[" + track_list_js_string + "]"
	
end

get '/:id'  do |release_id|

	file = File.new("credentials","r")	
	key = file.gets.split.join("\n")
	secret = file.gets.split.join("\n")
			
	@api_client = Sevendigital::Client.new(
		:oauth_consumer_key => key,
        :oauth_consumer_secret => secret,
        :lazy_load? => true,
        :country => country,
        :cache => VerySimpleCache.new,
        :verbose => "verbose"
   )
	  	
	options = {}
	options[:imageSize] = 350
	release = @api_client.release.get_details(release_id,options)
	release_tracks = @api_client.release.get_tracks(release_id)
  
	key_param = "&oauth_consumer_key=" + key
	
	@track_list_js_string = track_list_string(release_tracks,key_param)	
	@release_id = release_id  
	@release_image_url = release.image
	@release_name = "#{release.artist.name} - #{release.title}"
	@release_buy_url = release.url

	haml :index
end
  


