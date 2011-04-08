get '/search' do
  	country = get_country

  	credentials = Credentials.new
	api_client = get_api_client credentials, country

  	@user = session[:user]
  	@basket = get_basket api_client

	model = SearchModel.new
	model.country = country
	haml :index, :locals => {:model => model}
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

	model = SearchModel.new
	model.country = country
	model.search_value = search_value
	model.releases = releases
  	model.artists = artists
  	model.tracks = tracks
  	model.page_size = page_size

	haml :search_results, :locals => {:model => model}
end
