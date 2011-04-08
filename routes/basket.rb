get '/basket/add/:release_id/:track_id' do |release_id,track_id|
  country = get_country
  credentials = Credentials.new
  api_client = get_api_client credentials, country

  session[:basket] = api_client.basket.add_item(session[:basket].id,release_id, track_id)

  redirect "/#{country}"
end

get '/basket/add/:release_id' do |release_id|
  country = get_country
  credentials = Credentials.new
  api_client = get_api_client credentials, country

  session[:basket] = api_client.basket.add_item(session[:basket].id,release_id)

  redirect "/#{country}"
end

get '/basket/remove/:item_id' do  |item_id|
  country = get_country
  credentials = Credentials.new
  api_client = get_api_client credentials, country

  session[:basket] = api_client.basket.remove_item(session[:basket].id,item_id)

  redirect "/#{country}"
end