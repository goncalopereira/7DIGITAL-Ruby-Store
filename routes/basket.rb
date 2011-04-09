get %r{/basket/add/([0-9]+)(\/?)([0-9]*)} do |release_id,slash,track_id|
  
	if track_id == ''
		track_id = nil
	end

	session[:basket] = @api_client.basket.add_item(session[:basket].id,release_id, track_id)

  	redirect '/'
end

get %r{/basket/remove/([0-9]+)} do  |item_id|

  session[:basket] = @api_client.basket.remove_item(session[:basket].id,item_id)

  redirect '/'
end
