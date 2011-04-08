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

	model = ReleaseModel.new
  	model.label = release.label.name
  	model.release_date = release.release_date
  	model.image_url = release.image
	model.release_name = release.title
	model.tracks = release_tracks
	model.artist_name = release.artist.name
	model.url = release.url
  	model.release_id = release.id
  	model.country = country
 	model.price = release.price

	haml :release, :locals => {:model => model}
end
