require 'rubygems'
require 'sevendigital'
require 'sinatra'
require 'haml'
load 'lib/very_simple_cache.rb'
load 'lib/js_strings.rb'
load 'lib/credentials.rb'
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

	@model = ReleaseModel.new
  @model.label = release.label.name
  @model.release_date = release.release_date
  @model.image_url = release.image
	@model.release_name = release.title
	@model.tracks = release_tracks
	@model.artist_name = release.artist.name
	@model.url = release.url

	haml :release
end