get '/artist/:id' do |artist_id|
  options = {}
  options[:imageSize] = @main_image_size

  artist = @api_client.artist.get_details(artist_id,options)
  artist_releases = @api_client.artist.get_releases(artist_id, options={})

  model = ArtistModel.new
  model.image_url = artist.image
  model.url = artist.url
  model.artist_name = artist.name
  model.releases = artist_releases

  haml :artist, :locals => {:model => model}
end
