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

  model = ArtistModel.new
  model.image_url = artist.image
  model.url = artist.url
  model.artist_name = artist.name
  model.releases = artist_releases
  model.country = country

  haml :artist, :locals => {:model => model}
end
