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

enable :sessions

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

def get_user_and_basket user, basket, api_client
  @user = user

  if basket == nil
    basket = api_client.basket.create()
    session[:basket] = basket
  end

  @basket = basket
end

get '/:country' do |country|
	credentials = Credentials.new
	@api_client = get_api_client credentials, country

  get_user_and_basket session[:user],session[:basket], @api_client

	@model = SearchModel.new
	@model.country = country
	haml :index
end 

post '/search/:country' do |country|

	search_value = params[:search_value]
	page_size = params[:number_results]

	credentials = Credentials.new
	@api_client = get_api_client credentials, country

  get_user_and_basket session[:user],session[:basket], @api_client

	releases = @api_client.release.search(search_value, :page_size=>page_size)
  artists = @api_client.artist.search(search_value, :page_size=>page_size)
  tracks = @api_client.track.search(search_value, :page_size=>page_size)

	@model = SearchModel.new
	@model.country = country
	@model.search_value = search_value
	@model.releases = releases
  @model.artists = artists
  @model.tracks = tracks
  @model.page_size = page_size

	haml :search_results
end

post '/:country/basket/add' do |country|
  credentials = Credentials.new
  @api_client = get_api_client credentials, country

  session[:basket] = @api_client.basket.add_item(session[:basket].id,params[:release_id])

  redirect "/#{country}"
end

post '/:country/basket/remove' do |country|
  credentials = Credentials.new
  @api_client = get_api_client credentials, country

  session[:basket] = @api_client.basket.remove_item(session[:basket].id,params[:item_id])

  redirect "/#{country}"
end

post '/:country/login' do |country|
  email = params[:email]
  password = params[:password]

	credentials = Credentials.new
	@api_client = get_api_client credentials, country

  session[:user] = @api_client.user.authenticate(email,password)

  redirect "/#{country}"
end

post '/:country/logout' do |country|
  session[:user] = nil
  redirect "/#{country}"
end

get '/:country/artist/:id' do |country,artist_id|

  credentials = Credentials.new
  @api_client = get_api_client credentials, country

  get_user_and_basket session[:user],session[:basket], @api_client

  options = {}
  options[:imageSize] = 350

  artist = @api_client.artist.get_details(artist_id,options)
  artist_releases = @api_client.artist.get_releases(artist_id, options={})

  @model = ArtistModel.new
  @model.image_url = artist.image
  @model.url = artist.url
  @model.artist_name = artist.name
  @model.releases = artist_releases
  @model.country = country

  haml :artist
end

get '/:country/:id'  do |country,release_id|
	credentials = Credentials.new
	@api_client = get_api_client credentials, country

  get_user_and_basket session[:user],session[:basket], @api_client

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
  @model.release_id = release.id
  @model.country = country

	haml :release
end