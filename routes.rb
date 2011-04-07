require 'rubygems'
require 'sevendigital'
require 'sinatra'
require 'haml'
load 'lib/partials.rb'
load 'lib/very_simple_cache.rb'
load 'lib/js_strings.rb'
load 'lib/credentials.rb'
load 'models/release_model.rb'
load 'models/search_model.rb'
load 'models/artist_model.rb'

use Rack::Session::Pool

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

def get_basket api_client
  if session[:basket] == nil
    session[:basket] = api_client.basket.create()
  end

  session[:basket]
end

def get_country
  if session[:country] == nil
    'GB'
  else
    session[:country]
  end
end

post '/search' do
  country = get_country
	search_value = params[:search_value]
	page_size = params[:number_results]

	credentials = Credentials.new
	api_client = get_api_client credentials, country

  @user = session[:user]
  @basket = get_basket @api_client

	releases = api_client.release.search(search_value, :page_size=>page_size)
  artists = api_client.artist.search(search_value, :page_size=>page_size)
  tracks = api_client.track.search(search_value, :page_size=>page_size)

	@model = SearchModel.new
	@model.country = country
	@model.search_value = search_value
	@model.releases = releases
  @model.artists = artists
  @model.tracks = tracks
  @model.page_size = page_size

	haml :search_results
end

post '/basket/add' do
  country = get_country
  credentials = Credentials.new
  api_client = get_api_client credentials, country

  session[:basket] = api_client.basket.add_item(session[:basket].id,params[:release_id], params[:track_id])

  redirect "/#{country}"
end

post '/basket/remove' do
  country = get_country
  credentials = Credentials.new
  api_client = get_api_client credentials, country

  session[:basket] = api_client.basket.remove_item(session[:basket].id,params[:item_id])

  redirect "/#{country}"
end

get '/login' do
  puts 'login'
  haml :login
end

post '/login' do
  country = get_country
  email = params[:email]
  password = params[:password]

	credentials = Credentials.new
	api_client = get_api_client credentials, country

  session[:user] = api_client.user.authenticate(email,password)

  redirect "/#{country}"
end

post '/logout' do
  session[:user] = nil
  redirect "/"
end

get '/artist/:id' do |artist_id|
  country = get_country
  credentials = Credentials.new
  api_client = get_api_client credentials, country

  @user = session[:user]
  @basket = get_basket api_client

  options = {}
  options[:imageSize] = 350

  artist = api_client.artist.get_details(artist_id,options)
  artist_releases = api_client.artist.get_releases(artist_id, options={})

  @model = ArtistModel.new
  @model.image_url = artist.image
  @model.url = artist.url
  @model.artist_name = artist.name
  @model.releases = artist_releases
  @model.country = country

  haml :artist
end

get '/release/:id'  do |release_id|
  country = get_country
	credentials = Credentials.new
	api_client = get_api_client credentials, country

  @user = session[:user]
  @basket = get_basket api_client

	options = {}
	options[:imageSize] = 350
	
	release = api_client.release.get_details(release_id,options)
	release_tracks = api_client.release.get_tracks(release_id)

	@model = ReleaseModel.new
  @model.label = release.label.name
  @model.release_date = release.release_date
  @model.image_url = release.image
	@model.release_name = release.title
	@model.tracks = release_tracks
	@model.artist_name = release.artist.name
	@model.url = release.url
  @model.release_id = release.id
  @model.country = country

	haml :release
end

get '/:country' do |country|
  session[:country] = country
	redirect '/'
end


get '/' do
  country = get_country

  credentials = Credentials.new
	api_client = get_api_client credentials, country

  @user = session[:user]
  @basket = get_basket api_client

	@model = SearchModel.new
	@model.country = country
	haml :index
end
