before do 
	country = get_country
	credentials = Credentials.new
	@api_client = get_api_client credentials, country
	
	@user = session[:user]
	@basket = get_basket @api_client
	
	@main_image_size = 350
	@tile_image_size = 100

end

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
  if session[:basket].nil?
    session[:basket] = api_client.basket.create()
  end

  session[:basket]
end

def get_country
  if session[:country].nil?
    'GB'
  else
    session[:country]
  end
end

