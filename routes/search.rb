post '/search' do
	search_value = params[:search_value]
	page_size = params[:number_results]

	releases = @api_client.release.search(search_value, { :page_size=>page_size, :image_size=>@tile_image_size})
  	artists = @api_client.artist.search(search_value, { :page_size=>page_size, :image_size=>@tile_image_size})
  	tracks = @api_client.track.search(search_value, :page_size=>page_size)

	model = SearchModel.new
	model.search_value = search_value
	model.releases = releases
  	model.artists = artists
  	model.tracks = tracks
  	model.page_size = page_size

	haml :search_results, :locals => {:model => model}
end
