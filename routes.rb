require 'rubygems'
gem 'rack', '~> 1.1.0'
require 'sinatra'
require 'public/7digital/lib/sevendigital'
require 'haml'
load 'lib/verysimplecache.rb'
load 'lib/js_strings.rb'
load 'lib/api_service.rb'
load 'lib/credentials.rb'
load 'domain/track.rb'
load 'models/release_model.rb'

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

	@model = ReleaseModel.new(release.image,release.artist.name,release.title,release.url,tracks)
	
	haml :index
end
  


