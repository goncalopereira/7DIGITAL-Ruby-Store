before do 
	@country = get_country
	@api_client = get_api_client @country
	
	@user = session[:user]
	@basket = get_basket @api_client, @country
	
	@main_image_size = 350
	@tile_image_size = 100

end

def get_api_client country
		
	return Sevendigital::Client.new(
		:oauth_consumer_key => settings.api_key,
        	:oauth_consumer_secret => settings.api_secret,
        	:lazy_load? => true,
        	:country => country,
        	:cache => VerySimpleCache.new,
        	:verbose => "verbose"
   )	  	   
end


