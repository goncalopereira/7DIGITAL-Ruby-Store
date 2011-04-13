def get_basket api_client
  if session[:basket].nil?
    session[:basket] = api_client.basket.create()
  end

  session[:basket]
end

def set_basket basket
	session[:basket] = basket
end

def get_country
  if session[:country].nil?
    'GB'
  else
    session[:country]
  end
end

def set_country country
	session[:country] = country
end
	
