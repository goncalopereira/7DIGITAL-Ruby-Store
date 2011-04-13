get %r{/([A-Z][A-Z])?} do |country|

  	if !country.nil? and country != ''
		set_country country
		set_basket nil
		redirect '/' #refresh api_client with new country...
	end
	
	@release_chart = @api_client.release.get_chart()
	
	haml :index
end

