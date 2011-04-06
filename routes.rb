require 'rubygems'
require 'sevendigital'
require 'sinatra'
require 'haml'
load 'lib/verysimplecache.rb'
load 'lib/js_strings.rb'
load 'lib/api_service.rb'
load 'lib/credentials.rb'
load 'domain/track.rb'
load 'models/release_model.rb'
load 'models/search_model.rb'

def get_api_client credentials, country
		
	return Sevendigital::Client.new(
		:oauth_consumer_key => credentials.key,
        :oauth_consumer_secret => credentials.secret,
        :lazy_load? => true,
        :country => country,
        :cache => VerySimpleCache.new,
        :verbose => "verbose"
   )	  	   
end

get '/:country' do |country|
	@model = SearchModel.new
	@model.country = country
	haml :index
end 

post '/search/:country' do |country|

	search_value = params[:search_value]
	
	credentials = Credentials.new
	@api_client = get_api_client credentials, country
	
	releases = @api_client.release.search(search_value, :page_size=>20)
	
	@model = SearchModel.new
	@model.country = country
	@model.search_value = search_value
	@model.releases = releases
	haml :search_results
end

get '/:country/:id'  do |country,release_id|
	credentials = Credentials.new
	@api_client = get_api_client credentials, country
	options = {}
	options[:imageSize] = 350
	
	release = @api_client.release.get_details(release_id,options)
	release_tracks = @api_client.release.get_tracks(release_id)

	api_service = APIService.new
	tracks = api_service.get_tracks(release_tracks,credentials.key)

	@model = ReleaseModel.new(release.image,release.artist.name,release.title,release.url,tracks)
	
	haml :release
end
 
