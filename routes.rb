require 'rubygems'
gem 'rack', '~> 1.1.0'
require 'sinatra'
require 'public/7digital/lib/sevendigital'
require 'net/http'
require 'xmlsimple'
require 'haml'
load 'verysimplecache.rb'
load 'js_helper.rb'
load 'credentials.rb'

get '/:country/:id'  do |country,release_id|
	
	credentials = Credentials.new
		
	@api_client = Sevendigital::Client.new(
		:oauth_consumer_key => credentials.key,
        :oauth_consumer_secret => credentials.secret,
        :lazy_load? => true,
        :country => country,
        :cache => VerySimpleCache.new,
        :verbose => "verbose"
   )
	  	
	options = {}
	options[:imageSize] = 350
	
	release = @api_client.release.get_details(release_id,options)
	release_tracks = @api_client.release.get_tracks(release_id)
	
	extra_key_parameters_per_track = "&oauth_consumer_key=" + credentials.key
	
	js_string_helper = JSHelper.new
	
	@track_list_js_string = js_string_helper.track_list_string(release_tracks,extra_key_parameters_per_track)		
	@release_id = release_id  
	@release_image_url = release.image
	@release_name = "#{release.artist.name} - #{release.title}"
	@release_buy_url = release.url

	haml :index
end
  


