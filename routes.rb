require 'rubygems'
gem 'rack', '~> 1.1.0'
require 'sinatra'
require 'public/7digital/lib/sevendigital'
require 'haml'
load 'verysimplecache.rb'
load 'js_strings.rb'
load 'api_service.rb'
load 'credentials.rb'
load 'track.rb'

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
		
	js_string_helper = JSStrings.new
	api_service = APIService.new
	
	tracks = api_service.get_tracks(release_tracks,credentials.key)
		
	@track_list_js_string = js_string_helper.track_list_string(tracks)		
	@release_id = release_id  
	@release_image_url = release.image
	@release_name = "#{release.artist.name} - #{release.title}"
	@release_buy_url = release.url

	haml :index
end
  


