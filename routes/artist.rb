get %r{/artist/([0-9]+)} do |artist_id|
  	options = {}
  	options[:imageSize] = @main_image_size

	artist = @api_client.artist.get_details(artist_id,options)
	
	pass if artist.nil? 

  	artist_releases = @api_client.artist.get_releases(artist_id, options={})

	similar_artists = @api_client.artist.get_similar(artist_id)
	top_tracks = @api_client.artist.get_top_tracks(artist_id)

  	model = ArtistModel.new
  	model.image_url = artist.image
  	model.url = artist.url
  	model.artist_name = artist.name
  	model.releases = artist_releases
	model.similar_artists = similar_artists
	model.top_tracks = top_tracks

	haml :artist, :locals => {:model => model}
end
