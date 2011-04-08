get '/basket/add/:release_id/:track_id' do |release_id,track_id|
  session[:basket] = @api_client.basket.add_item(session[:basket].id,release_id, track_id)

  redirect '/'
end

get '/basket/add/:release_id' do |release_id|

  session[:basket] = @api_client.basket.add_item(session[:basket].id,release_id)

  redirect '/'
end

get '/basket/remove/:item_id' do  |item_id|

  session[:basket] = @api_client.basket.remove_item(session[:basket].id,item_id)

  redirect '/'
end
