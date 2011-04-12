def get_basket api_client, country
  if session[:"basket#{country}"].nil?
    session[:"basket#{country}"] = api_client.basket.create()
  end

  session[:"basket#{country}"]
end

def set_basket basket, country
	session[:"basket#{country}"] = basket
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
	
